package de.wwu.embdsys.sc2pvl.engine;

import java.io.FileNotFoundException;

import java.io.PrintWriter;
import java.util.Map;

import de.tub.pes.syscir.engine.util.CommandLineParser;
import de.tub.pes.syscir.sc_model.SCSystem;
import de.wwu.embdsys.sc2pvl.pvlmodel.PVLClass;
import de.wwu.embdsys.sc2pvl.pvlmodel.PVLSystem;
import de.wwu.embdsys.sc2pvl.util.Constants;


public class Engine {

	/**
	 * @param args
	 */
	public static void main(String[] args) {

		Map<String, String> argMap = CommandLineParser.parseArgs(args);

		//NOT ENOUGH ARGUMENTS
		if (argMap.size() == 0) {
			System.out.println("Insufficent number of parameters. Use -h for help.");
			return;
		}

		//PRINT HELP
		if (argMap.containsKey("h") || argMap.containsKey("H")) {
			Engine.printHelpInConsole();
			return;
		}

		String fileIn = null;
		String folderOut = null;

		//INPUT FILE
		if (argMap.containsKey("i")) {
			fileIn  = argMap.get("i");
		} else {
			System.out.println("No input directory specified. Use -h for help.");
			return;
		}
		//OUTPUT FILE
		if (argMap.containsKey("o")) {
			folderOut = argMap.get("o");
		} else {
			System.out.println("No output directory specified. Use -h for help.");
		}
		
		

		long time_resolution = 1l;
		//TIME RESOLUTION
		if (argMap.containsKey("tr")) {
			try {
				time_resolution = Long.parseLong(argMap.get("tr"));
			} catch (NumberFormatException ex) {
				System.out.println("Invalid time resolution; defaulting to 1.");
			}
			Constants.SC_TIME_RESOLUTION = time_resolution;
		} else {
			Constants.SC_TIME_RESOLUTION = 1l; // default: time resolution in nanoseconds
		}
		System.out.println("Transforming file " + fileIn + " to pvl. Chosen time resolution: " + time_resolution +"ns.");

		//START TRANSFORMATION
		Engine e = new Engine();
		e.transform(fileIn, folderOut);
		System.out.println("Transformation finished. Files written to directory: " + folderOut);
	}

	public void transform(String in, String out) {	
		

		SCSystem scs = de.tub.pes.syscir.engine.Engine.buildModelFromFile(in);
		Transformer transformer = new Transformer(scs);
		transformer.createPVLModel();
		writeOut(out, transformer.getPVLSystem());	
	}

	/**
	 * Write PVL CLasses to files PVL files.
	 * 
	 * @param pvl_system all classes that need to be written into files
	 */
	public static void writeOut(String location, PVLSystem pvl_system) {
		for (PVLClass pvl_class : pvl_system.getClasses()) {
			String filename = location + pvl_class.getName() + ".pvl";
			try (PrintWriter out = new PrintWriter(filename)) {
				String class_contents = pvl_class.toString();
				class_contents = formatFile(class_contents);
				out.println(class_contents);
				out.close();
			} catch (FileNotFoundException e) {
				System.out.println("Error during file creation.");
				e.printStackTrace();
			}
		}
	}

	/**
	 * Formats a file by adding indentations.
	 * 
	 * @param pvl_file The file to be indented.
	 * @return
	 */
	public static String formatFile(String pvl_file) {
		// split by line
		String[] lines = pvl_file.split("\n");
		String res = "";
		int indent = 0;
		int indent_line = 0;
		boolean in_spec_block = false;
		for (String line : lines) {
			if (line.contains("}") && !line.contains("{"))
				indent -= line.chars().filter(ch -> ch == '}').count();
			indent_line = indent;
			if (line.contains("else")) {
				// TODO: ugly but works. "else" lines contain both } and {, but should be indented one line less
				indent_line -= 1;
			}
			if (line.contains("{") && !line.contains("}"))
				indent += line.chars().filter(ch -> ch == '{').count();
			if (!in_spec_block && line.trim().endsWith("**")) {
				in_spec_block = true;
				indent += 2;
			}
			if (in_spec_block && line.trim().endsWith(";")) {
				in_spec_block = false;
				indent -= 2;
			}
			res += "    ".repeat(indent_line) + line + "\n";
		}
		return res;
	}

	/**
	 * prints the description of all possible arguments
	 * in the console
	 */
	private static void printHelpInConsole() {
		System.out.println("Call should be of form: -i path/to/ast_file -o path/to/results/dir -tr timeresolutioninnanoseconds");
	}
}
