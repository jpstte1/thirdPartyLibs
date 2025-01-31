#######################################
#
# Pine - gcc - onemkl
#
# Uses :
#   - oneAPI MKL    for BLAS and LAPACK
#
#######################################
#
# Requires:
#
########################################
module purge
module load gcc/12.2.0
module load openmpi-gcc/4.1.6
module load cmake/3.27.9
module load aocl/4.1.0-gcc
module load intel/OneAPI_2023.1
module load mpi/2021.9.0
module load mkl/2023.1.0

export HDF5_USE_FILE_LOCKING=FALSE

set( CONFIG_NAME "Pine" CACHE PATH "" )

include(${CMAKE_CURRENT_LIST_DIR}/pangea4-base.cmake)

#######################################
# COMPILER SETUP
#######################################

# use :

if( NOT DEFINED ENV{GCC_PATH} )
    message( FATAL_ERROR "GCC is not loaded. Please load the gcc/12.2.0 module." )
endif()

set( CMAKE_C_COMPILER       "mpicc"  CACHE PATH "" )
set( CMAKE_CXX_COMPILER     "mpic++"  CACHE PATH "" )
set( CMAKE_Fortran_COMPILER "mpif90" CACHE PATH "" )

set( COMMON_FLAGS  "-m64 -march=native -mtune=native" )
set( RELEASE_FLAGS "-O3 -DNDEBUG"                )
set( DEBUG_FLAGS   "-O0 -g"                      )

set( CMAKE_C_FLAGS               ${COMMON_FLAGS}  CACHE STRING "" )
set( CMAKE_CXX_FLAGS             ${COMMON_FLAGS}  CACHE STRING "" )
set( CMAKE_Fortran_FLAGS         ${COMMON_FLAGS}  CACHE STRING "" )
set( CMAKE_CXX_FLAGS_RELEASE     ${RELEASE_FLAGS} CACHE STRING "" )
set( CMAKE_C_FLAGS_RELEASE       ${RELEASE_FLAGS} CACHE STRING "" )
set( CMAKE_Fortran_FLAGS_RELEASE ${RELEASE_FLAGS} CACHE STRING "" )
set( CMAKE_CXX_FLAGS_DEBUG       ${DEBUG_FLAGS}   CACHE STRING "" )
set( CMAKE_C_FLAGS_DEBUG         ${DEBUG_FLAGS}   CACHE STRING "" )
set( CMAKE_Fortran_FLAGS_DEBUG   ${DEBUG_FLAGS}   CACHE STRING "" )

#######################################
# MPI SETUP
#######################################

set( ENABLE_MPI ON CACHE BOOL "" )

#if( NOT DEFINED ENV{HPCX_MPI_DIR} )
#    message( FATAL_ERROR "HPC-X OpenMPI is not loaded. Please load the hpcx module." )
#endif()

#######################################                                                                                                                                           
# BLAS/LAPACK SETUP                                                                                                                                                               
#######################################

# use :
# - intel oneAPI MKL library

set( ENABLE_MKL ON CACHE BOOL "" FORCE )

if( NOT DEFINED ENV{MKLROOT} )
    message( FATAL_ERROR "MKL is not loaded. Please load the intel-oneapi-mkl/2023.2.0 module." )
endif()

set( MKL_INCLUDE_DIRS $ENV{MKLROOT}/include CACHE STRING "" )
set( MKL_LIBRARIES    $ENV{MKLROOT}/lib/intel64/libmkl_rt.so
                      /usr/lib64/libgomp.so.1
                      CACHE STRING "" )

#
# Turn off GOOGLE Test because it requires BLT installation on linux.... let's try without it...
#
set(ENABLE_GTEST_DEATH_TESTS OFF CACHE BOOL "")
