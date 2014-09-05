/*
  DA-NRW Software Suite | ContentBroker
  Copyright (C) 2014 LVRInfoKom
  Landschaftsverband Rheinland

  This program is free software: you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation, either version 3 of the License, or
  (at your option) any later version.

  This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.

  You should have received a copy of the GNU General Public License
  along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

package de.uzk.hki.da.format;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.util.List;

import de.uzk.hki.da.model.DAFile;

/**
 * Provides access to the file format subsystem, which is responsible for identification of file and container 
 * formats, extraction of metadata from files, and validation of file formats.
 * 
 * @author Daniel M. de Oliveira
 */
public interface FileFormatFacade {

	/**
	 * Scans all files and determines the pronom PUID and possibly a secondary format attribute
	 * for each of them. Then sets a value for each of the files formatPUID and formatSecondaryAttribute fields.
	 * 
	 * @param files
	 * @return return files. Used for easier testing.
	 * @throws FileNotFoundException if one or more files cannot be found.
	 * @throws FileFormatException if format could not get determinded.
	 */
	public List<DAFile> identify(List<DAFile> files) 
			throws FileNotFoundException, FileFormatException;

	/**
	 * The target directory must exist
	 * 
	 * @param file
	 * @param jobId
	 * @return
	 * @throws IOException
	 */
	public void extract(File file, File extractedMetadata) throws IOException;
}