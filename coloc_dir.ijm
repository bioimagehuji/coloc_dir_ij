// ImageJ macro for colocalization of all images in a directory.
// Required FIJI plugin: Colocalization_Finder, http://questpharma.u-strasbg.fr/html/colocalization-finder.html

im_dir = getDirectory("Choose folder");
print(im_dir);
replace(im_dir, "\\", "/");
print(im_dir);

close("*");
close("Colocalization Finder Results")

file_list = getFileList(im_dir); 
for (i = 0; i < file_list.length; i++) { 
	close("*");
	image = file_list[i]; 
	if (endsWith(image, ".nd2")) {
		run("Bio-Formats Importer", "open=[" + im_dir + image + "] autoscale color_mode=Default rois_import=[ROI manager] split_channels view=Hyperstack stack_order=XYCZT");
		selectImage(image + " - C=0");
		close();
		run("Colocalization Finder", "image_1=[" + image +" - C=1] image_2=["  + image +" - C=2] scatterplot_size=[_512 x 512_] ");
		selectImage("ScatterPlot");
		call("Colocalization_Finder.setScatterPlotRoi", 100, 4095, 100, 4095);
		filename = call("Colocalization_Finder.analyzeByMacro", "true", "false",0);
	}
}
close("*");
selectWindow("Colocalization Finder Results");
saveAs("Text", im_dir + "Colocalization Finder Results.csv");
