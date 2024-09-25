<body>
    <h1>Histogram Equalization of 256-Level Grayscale Images in VHDL :cd:</h1>
    <p>This repository contains the VHDL code for the final project of the "Progetto Reti Logiche" course (Academic Year 2020/2021). The project focuses on the design of a VHDL component for histogram equalization of grayscale images with 256 intensity levels.</p>
    <h2>Project Overview</h2>
    <p>The objective of this project is to process a given grayscale image (with a maximum resolution of 128x128 pixels) to enhance its contrast using histogram equalization. The implementation is done entirely in VHDL, and it is capable of reading an image, processing it, and writing the equalized version back to memory.</p>
    <h2>Features</h2>
    <ul>
        <li><strong>Image Processing in VHDL:</strong> Handles 256-level grayscale images with a resolution of up to 128x128 pixels.</li>
        <li><strong>Histogram Equalization:</strong> Adjusts the contrast of the image by redistributing pixel intensity values.</li>
        <li><strong>Test Bench:</strong> Includes a set of test cases for verifying the functionality under various conditions, including edge cases.</li>
        <li><strong>Memory Architecture:</strong> The image data is stored and processed using a memory structure that is accessed during the equalization process.</li>
    </ul>
    <h2>File Structure</h2>
    <ul>
        <li><strong>10626444.vhd</strong> - Contains the VHDL source files for the histogram equalization component.</li>
        <li><strong>10626444.pdf</strong> - Documentation for the project, including the original project report and details on the design, simulation, and synthesis results.</li>
        <li><strong>generator.c</strong> - Generates images of different sizes and contents to test the overall functionality of the component.</li>
    </ul>
    <h2>VHDL Component Interface</h2>
    <p>The VHDL component includes the following signals:</p>
    <ul>
        <li><strong>i_clk:</strong> Input clock signal (minimum period of 100 ns).</li>
        <li><strong>i_rst:</strong> Input reset signal to initialize the component.</li>
        <li><strong>i_start:</strong> Input start signal to begin processing the image.</li>
        <li><strong>i_data:</strong> Input data signal for reading image data from memory.</li>
        <li><strong>o_address:</strong> Output address signal for writing the processed data back to memory.</li>
        <li><strong>o_done:</strong> Output signal indicating that the processing is complete.</li>
        <li><strong>o_en:</strong> Output enable signal for memory access.</li>
        <li><strong>o_we:</strong> Output write enable signal for writing to memory.</li>
        <li><strong>o_data:</strong> Output data signal for the processed image data.</li>
    </ul>
    <h2>Test Cases</h2>
    <p>The following test cases have been executed to validate the functionality of the component:</p>
    <ol>
        <li>2x2 Image: Basic image processing test.</li>
        <li>Empty Image: Testing behavior with 0x0, Nx0, or 0xN images.</li>
        <li>Single Pixel: Processing an image with only one pixel.</li>
        <li>Consecutive Equalizations: Running multiple equalizations in the same simulation.</li>
        <li>All Zeros: Processing an image filled with zero values.</li>
        <li>All 255s: Processing an image filled with 255 values.</li>
        <li>Full Range: Testing an image with the full range of pixel values (0 to 255).</li>
        <li>Asynchronous Reset: Resetting the component during processing to check for correct behavior.</li>
        <li>128x128 Image: Processing an image with the maximum size of 128x128 pixels.</li>
    </ol>
    <h2>Synthesis Results</h2>
    <p>The component was synthesized using 214 Look-Up Tables (LUTs) and 108 Flip-Flops (FFs). The synthesized component meets the required performance and area constraints, with successful post-synthesis validation.</p>
    <h2>Conclusion</h2>
    <p>The VHDL component successfully performs histogram equalization on grayscale images as per the project specifications. The choice of a single module design ensures a clear and sequential flow, making the component well-suited for small to medium image sizes.</p>
</body>
</html>
