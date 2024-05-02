# 2024-Cunningham-MS-Thesis

The following consists of the files used to perform a fission gas release study on UO2 and UN fuels using the BISON fuel performance code. BISON is an export-controlled code that requires a license from the Idaho National Laboratory's (INL) Nuclear Computational Resource Center (NCRC): https://inl.gov/ncrc/
Please see https://bison.inl.gov/SitePages/Access.aspx for more information on how to obtain a license. 

These files ultimately create three-dimensional surface plots of the fission gas release threshold curve, similar to that of Vitanza, et al (https://inis.iaea.org/collection/NCLCollectionStore/_Public/11/544/11544784.pdf?r=1), but incorporating a third power axis. The x-axis displays burnup, the y-axis displays temperature, and the z-axis displays linear heat rate which may be correlated firectly to power.

These files are intended for use on a cluster. These were run on INL's Sawtooth cluster. WinSCP (https://winscp.net/eng/index.php) was used to transfer files to and from the cluster. PuTTY was used as the SSH client (https://www.putty.org/). Each file is described below with its intended use. The intended work flow is to run auto_generate_input_files.m > WinSCP generated input files to the cluster > run autorun.sh on the cluster to automate running each input file > WinSCP output files to the local machine > run auto_process_output.m to combine output files into one > run plot_3d_vitanza.m to generate the 3D surface plot.

auto_generate_input_files.m >> This MATLAB file changes the input linear heat rate in each input file it generates. To use this file, update the basename on line 3 to your preference for the generated input file names. Update the name of the contents file on line 4 to whatever input file you are adjusting. Update the for loop intervals on line 7 to the desired range of linear heat rates. For example, this version will generate the following input files: vitanza_UN_p_6500.i, vitanza_UN_p_7500.i, vitanza_UN_p_8500.i, ... and the integer in each file name represents the linear heat rate in W/m of the input file.

auto_generate_input_files_pow_temp.m >> This MATLAB file is identical to auto_generate_input_files.m, but uses two for-loops to also change the fuel surface temperature boundary condition for the BISON calculation. Specifically, line 9  iterates through a range of temperatures. This produces input files with changing linear heat rates [W/m] and fuel surface temperatures [K]. For example, this version will generate the following input files: vitanza_UN_t_p_1215_6500.i, vitanza_UN_t_p_1225_6500.i, ... vitanza_UN_t_p_1215_7500.i, vitanza_UN_t_p_1225_7500.i, ... ... and the first integer in each file name represents the fuel surface temperature boundary condition in K in the input file and the second integer represents the linear heat rate in W/m in the input file.

vitanza_UN_base_3.i >> This is the BISON input file for the UN fission gas release model. This file is the file you will reference in auto_generate_input_files.m line 4. The auto_generate_input_files.m file changes the linear heat rate on line 44 in this file. The auto_generate_input_files.m file changes the linear heat rate on line 44 in this file and the fuel surface temperature boundary condition on line 108 in this file.

vitanza_UO2_base_1.i >> This is the BISON input file for the UO2 fission gas release model. This file is the file you will reference in auto_generate_input_files.m line 4. The auto_generate_input_files.m file changes the linear heat rate on line 41 in this file. The auto_generate_input_files.m file changes the linear heat rate on line 41 in this file and the fuel surface temperature boundary condition on line 104 in this file.

mesh.e >> This is the mesh file for the UN and UO2 models and should be included in the file uploads to the cluster. The UN BISON input file references this mesh file on line 21 and the UO2 BISON input file references this mesh file on line 20. The input files will not run if this mesh file is not included in the working directory. 

autorun.sh >> This is a shell script written in bash. This is designed to automatically run all input files in serial on a cluster that uses PBS job scheduling. Lines 2-5 may need to be altered depending on the scheduler type. the filename in line 13 will need to be updated to the file basename used. Line 17 may need to be altered depending on where your bison-opt script is located.

auto_process_output.m >> This MATLAB file is used to extract properties of interest from output csv files into a single csv, "processed_output.csv" for plotting. The interval in the for loop in line 7 must match the for loop interval in auto_generate_input_files.m.

auto_process_output_pow_temp.m >> This MATLAB file is used to extract properties of interest from output csv files into a single csv, "processed_output.csv" for plotting. The two intervals in the for loops in lines 9 and 11 must match the for loop intervals in auto_generate_input_files_pow_temp.m. This is identical to auto_generate_input_files.m but includes the iterations in temperature, in addition to linear heat rate.

plot_3d_vitanza.m >> This MATLAB file is used to create an interpolated 3D mesh surface plot from the "processed_output.csv" generated from auto_process_output.m or auto_process_output_pow_temp.m



For questions or comments, please contact the author, Kaylee Cunningham, at cunninghamkayleem@gmail.com.
