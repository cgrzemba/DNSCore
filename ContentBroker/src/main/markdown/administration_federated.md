## Administration of DNS in iRODS federated mode

### Introduction

There are two modes in which you might run DNScore with iRODS as storage layer.

For more separated and independent iRODS "nodes" of DNSCore and to do "load balancing" having more nodes then just three - and  to avoid overhead of administration at the Master ICAT Zone Server in the integrated
mode, you could decide to run DNSCore and iRODS in the so called "federated mode". In the federated mode you have several distinct Master ICAT Zones 
forming a releativley loosley coupled Federation in terms of iRODS Servers. 

In this topology your nodes admins should be able to administer iRODS Master servers and the federation itself
(See iRODS documentation about this: https://irods.sdsc.edu/index.php/Federation_Administration). Most of the effort has to be done once during setup. The daly maintenance is quite easily and does not differ from the single zone administration effort.

Although the iRODS servers are more separated, they still still share some common infrastructure (e.g. Object-DB), they form still a "domain" of shared functionalities.

The functionalities described below are compatible to a landscape in which "integrated", "one zone" approach has worked before, though the "federated" mode sits "on top" the integrated mode.

But you can't mix both modes in one Domain yet.

### Definitions

The node on which the itmes are stored first is the "primary copy", the node is "the responsible node" for that dedicated item. It's supposed to be the primary node for inquires about data, sending deltas etc.

All other nodes having copies of the stored items are therefore called "secondary copies". The serve as backup in case of data loss or bit courruption at the primary one. 

### Prerequisites

As needed by iRODs Installation you will need PostgreSQL Database support at each node.

1. Running iRODS Server > 3.2 at zoneA ([here](https://github.com/da-nrw/DNSCore/blob/master/ContentBroker/src/main/markdown/installation_irods_cb.md))
1. Running iRODS Server > 3.2 at zoneB
1. Running ContentBroker 
1. Running Federation between zoneA and zoneB https://irods.sdsc.edu/index.php/Federation_Administration) 
1. Federated RuleSet dns.re from ([here](https://github.com/da-nrw/DNSCore/blob/master/ContentBroker/src/main/rules/irodsFederatedGridFacade/dns.re)) activated 
in server.config. 

### Changes needed to ContentBroker

Change implementation of grid drivers to:

    cb.implementation.grid=federatedGridFacade
    cb.implementation.distributedConversion=irodsFederatedDistributedConversionAdapter
 
### Changes needed to iRODS

Create directory for federated items of other zones at zoneA

    imkdir /zoneA/federated

Set the rights for federated copies at least to "own" for the federated folders
e.g.

     ichmod -r own rods#zoneB /zoneA/federated/CONTRACTOR_ZONEB
     
Please consider the most restrictive permissions you are able to set for this.

You should have a RescGroup "lza" containing your long term storage resource at each node. So the name of the RescGroupt must be same for all nodes. 

Please give a full "own" rights to user rods#zoneB recursively to folder /zoneA/pips
   
    ichmod -r own rods#zoneB /zoneA/pips

Please set inherit mode to enabled
 
 	ichmod -r inherit /zoneA/pips
 
Load the federated dns.re file from ([here](https://github.com/da-nrw/DNSCore/blob/master/ContentBroker/src/main/rules/irodsFederatedGridFacade/dns.re))
and install it to folder 

	iRODS/server/config/reConfigs 
	
Make sure you have enabled the reSet in the server.config as described ([here](https://github.com/da-nrw/DNSCore/blob/master/ContentBroker/src/main/markdown/installation_irods_cb.md)) and you have tested your still working installation by typing at least an 
"ils" command. 

You should be at least familiar with basic icommands such as :

	irsync 
	imeta
	iadmin mkresc
	ichmod
	ils -A
	ils -L
	itrim
	irule
	
Please refer to the iRODS Docs as well!
	
### How does it work?

Imagine having an AIP in logical namespace

	/zoneA/aip/TEST/123545/123545_pack.1.tar

While having a running "federation service" and a federation to zoneB you'll find your federated items
on zoneB at 
	
	/zoneB/federated/zoneA/aip/TEST/123545/123545_pack.1.tar
	
As you might already noticed: The path beneath federated is logically same as on zoneA.

### Federation Service

The Federation service works permanently on time based schedule. It tries to copy ("federate") your stored AIP like a "cron" daemon, it defines an service 

Start the Federation service, which could be found ([here](https://github.com/da-nrw/DNSCore/blob/master/ContentBroker/src/main/rules/irodsFederatedGridFacade/federate.r))

    irule -F federate.r
    
Take a look at the reLog (Rule engine log file) which could be found at 
	
	iRODs/server/logs/
	
The Federation service should claim: 

	--started Federation service---
	--ended Federation service---
	
What it does is: 

1. Takes into account given forbidden nodes settings stored by CB after registry of AIP.
1. Asks all Servers on your Grid for their already stored items. Measured by counting items sizes beneath "aip" folders and on longterm storage resources (which have to be member of resgroup lza). 
It takes into account all "own" and already federated items. This should do a load balancing between federated zones.
2. Order them ascending, the lowest filled resource first.
3. Trying to copy the items to all reachable nodes (zones) until reached numCopy setting stored by contentbroker - Or if not available, until the given minimal number is being reached. 
1. Store the original computed checksum to the copied AIP for reference
5. Retry until reached and copied with equality of checksums. (synchronize)

### Administer Federation

Once activated federation service runs, even iRODsSServer is restarted.

Start 
	irule -F federate.r

The Service asks for some settings after start:

	Default *destResc="lza"  
    New *destResc=
	Default *homezone="zone"
    New *homezone=
	Default *min_copies=3
    New *min_copies=
    
destResc : The resource group name, the syncing should go to,
homezone : The own zone name 
min_copies : The minimal copies need if not overruled by Clients (CB client does this in its preservation system)
	
check if Federation Service is running

	iqstat 

Command should list at least the Federation service

Delete Federation service 

	iqstat
	iqdel <ruleId>
	
Check Logfile for errors : reLog. 
If Federation service prints out any error numbers, you might evaluate the error codes to their corresponding textual textual representation with 

	ierror -333000

### Audit Infrastructure

To perform Audit (integrity checking) of AIP iRODS each node must at least provide the time based check 
service of federated copies. 

In this Service checkFederatedAip.r all federated copies MD5 checksums stored for others at "my zone" are recalculated 
on time basis. 

This is defined to be a "trust" between all servers of the zone.

irule -F checkFederatedAip.r ([here](https://github.com/da-nrw/DNSCore/blob/master/ContentBroker/src/main/rules/irodsFederatedGridFacade/checkFederatedAip.r))

	Default *zone="zone"
	New *zone=
	Default *admin="test@test.de"
	New *admin=
	Default *numbersPerRun=5
	New *numbersPerRun=
	Default *trustYears=0
	New *trustYears=

zone: The zone which this service should run-
admin: The Admin which should be infrmed on errors
numbersPerRun: Amount of Items being checked each time the service runs
trustYears: Value in years we trust a chekcsum before recomputation. 0 means each time recalculate, 0.5 means half a year etc. 

If the responsible node (which means the "primary copy node") is being asked for the integrity of AIP e.g. acIsValid() in dns.re 
is being triggered it it does the following:

1. Get The MD5 checksum for local primary copy from the ICAT.
2. Compare stored ICAT value with checksum computed at creation
3. Verify federated Checksums (relies on running service) 
4. Deep Verify (recompute) local Checksum

### AVU Metadata of iRODS Objects in DNS (AIP/DataObjects) 

Attribute Value Unit (AVU) Metadata are stored in each ICAT. They could be listed with 

	imeta ls -d 1-20141007788.pack_1.tar
	attribute: FEDERATED
	value: 1
	units: 
	----
	attribute: chksum
	value: 37996b3bedcfabf476a5b9c44b90d45b
	units: 
	----
	attribute: SYNCHRONIZED_TO
	value: lvr,
	units: 
	----
	attribute: replicate_to
	value: lza
	units: 
	----
	attribute: MIN_COPIES
	value: 2
	units: 
	----
	attribute: SYNCHRONIZE_EVENT
	value: 01412675041
	units: 

attribute: FEDERATED
AVU indicates if AIP was synchronized successfully

attribute: chksum
stores originally computed checksum

attribute: SYNCHRONIZED_TO
zones with secondary copies

attribute: replicate_to
Resc group names the item was replicated to after registry in local zone

attribute: MIN_COPIES
Minimal copies to reach (otherwise federation service's default, 3 is being taken)
 
attribute: SYNCHRONIZE_EVENT
timestamp of last synchronizing event 