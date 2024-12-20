# See https://git.yoctoproject.org/poky/tree/meta/files/common-licenses
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

# TODO: Set this  with the path to your assignments rep.  Use ssh protocol and see lecture notes
# about how to setup ssh-agent for passwordless access
SRC_URI = "git://git@github.com/ceca5556/ECEN-5713-ADAS.git;protocol=ssh;branch=master"


PV = "1.0+git${SRCPV}"
# TODO: set to reference a specific commit hash in your assignment repo
#SRCREV = "6ef3119241222cd41f2148d08447931188ca1768"
SRCREV = "${AUTOREV}"

inherit pkgconfig
DEPENDS = "pkgconfig opencv"
RDEPENDS_${PN} = "libopencv-core libopencv-imgproc libopencv-highgui libopencv-videoio libopencv-imgcodecs libopencv-gapi"

# This sets your staging directory based on WORKDIR, where WORKDIR is defined at 
# https://docs.yoctoproject.org/ref-manual/variables.html?highlight=workdir#term-WORKDIR
# We reference the "server" directory here to build from the "server" directory
# in your assignments repo
S = "${WORKDIR}/git/opencv_test"

# TODO: Add the aesdsocket application and any other files you need to install
# See https://git.yoctoproject.org/poky/plain/meta/conf/bitbake.conf?h=kirkstone
FILES:${PN} += "${bindir}/capture"

# TODO: customize these as necessary for any libraries you need for your application
# (and remove comment)
TARGET_LDFLAGS += "-pthread -lrt -L/usr/lib -lopencv_core -lopencv_flann -lopencv_video -lrt -lstdc++fs -lstdc++ -lopencv_gapi"


do_configure () {
	:
}

do_compile () {
	#oe_runmake
	${CXX} ${CXXFLAGS} ${LDFLAGS} ${S}/capture.cpp `pkg-config --cflags opencv4` `pkg-config --libs opencv4` -o capture
}

do_install () {
	# TODO: Install your binaries/scripts here.
	# Be sure to install the target directory with install -d first
	# Yocto variables ${D} and ${S} are useful here, which you can read about at 
	# https://docs.yoctoproject.org/ref-manual/variables.html?highlight=workdir#term-D
	# and
	# https://docs.yoctoproject.org/ref-manual/variables.html?highlight=workdir#term-S
	# See example at https://github.com/cu-ecen-aeld/ecen5013-yocto/blob/ecen5013-hello-world/meta-ecen5013/recipes-ecen5013/ecen5013-hello-world/ecen5013-hello-world_git.bb

	install -d ${D}${bindir}
	install -m 0755 ${S}/capture ${D}${bindir}/

}
