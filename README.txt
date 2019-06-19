Hi,

This development is referenced to https://github.com/scikit-learn-contrib/hdbscan .

Based on the papers:

McInnes L, Healy J. Accelerated Hierarchical Density Based Clustering In: 2017 IEEE International Conference on Data Mining Workshops (ICDMW), IEEE, pp 33-42. 2017 [pdf]

R. Campello, D. Moulavi, and J. Sander, Density-Based Clustering Based on Hierarchical Density Estimates In: Advances in Knowledge Discovery and Data Mining, Springer, pp 160-172. 2013

. Application could be started via MEF.m.
	Steps:
	-> Start click button in matlab.
	-> Folder picker will be started. (Please select file type from code i.e(.jpg or .png))
	-> Wait for result.

. load_images.m: Load image files and count thme, extract size information of images.
		 Read them and assign them to array then return it to main function.

. pre_claculations.m: Do pre calculations for main loop. Extract informations to complete algorithm.

. images: Contains test images.
	1) Eiffel: This folder contains 3 images and one inner folder. Inner folder(eiffel_results) contains result images with names according to parameters.
		Each of the images will be used by the application. (Be careful file extensions must be same in the code.)
	2) Jesus: This folder contains 8 images and one inner folder that contains result images and histograms.
	3) Notredame: This folder contains 5 images and 2 folders. easy_hdr_result contains result image that is copied from internet. Notredame results contains result and they were named according to parameters.
	4) StLouis: This folder contains 3 images and 3 folders. New Folder contains an image. This image is overexposure image.
		stlouis_results contains result images and histograms. stlouis_results_from_other_algorithms contains images from different algorithms. They were named according to algorithms.

. Presentation: Contains .pptx file.

. report: Contains project_report.docx file.

Oguzhan DURMUS
