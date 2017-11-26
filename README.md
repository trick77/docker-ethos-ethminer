# docker-ethos-ethminer
Docker image which makes building your own or preferred version of ethminer for ethOS super easy without polluting your system with openCL and CUDA libraries. The resulting binary can be used to replace the existing ethminer binary in /opt/miners/ethminer of your mining rig. Make sure to backup the existing binary though. Please be  aware that the new binary may get replaced with every manual update of ethOS and/or its miners. 

Build the image and start the container (which will exit immediately) with ```docker-compose up```

Building the image will take quite some time and download more than 1 GB of data. Build errors have to be fixed but shouldn't occur unless one of the referenced libraries (i.e. the CUDA toolkit) changes its name/availability.

Once the image build was successfuly and the container was created using the up command, the binaries can be copied from the container to the host with a simple ```docker cp docker-ethos-ethminer:/build/ethminer/build ./``` and then transferred to a mining rig.
