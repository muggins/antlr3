ANTLR version 3 supports target language generation for the lexical
analyzer and parsers. Objective C was supported previously but had not
been brought up to date for some time. This release is built on the work
by Kay Roepke, Ian Michell and Alan Condit.

The project is currently working sufficiently for me to use it in compiling
my grammar and tree walker. I am sure that it still has some bugs but I have
fixed all of the bugs that I have found so far.

The project passes all of the tests that we have implemented so far. As of
June 1, 2012 it now will generate ST4.0.5 templates correctly to at least
allow successful compilation and execution of the example PolyDiff.

The project consists of an Objective-C runtime framework that must be
installed in /Library/Frameworks.

It also requires the installation of the String Template files to
support the target language code generation. Hopefully, at some point
they will be incorporated into the ANTLR release code, so that the
individual user doesn't have to do anything but load the framework into
the proper location. However, for now you need to create an ObjC
directory in antlr-3.2/tool/src/main/resources/org/antlr/codegen/templates
and then copy the ObjC ".stg" files to
antlr-3.2/tool/src/main/resources/org/antlr/codegen/templates/ObjC/*.

There is also a java file ObjCTarget.java that goes in <
antlr-3.2/tool/src/main/java/org/antlr/codegen/ObjCTarget/Java>.

If you are using Antlr3.3 the code from here is included with the Antlr tarball. You just need
to copy the ANTLR.framework to /Library/Frameworks.

antlr3.4.1
Feb. 22, 2012 -- I just uploaded a new binary(zipped) copy of the ANTLR.framework and antlr3.4.jar
that has all of the renaming changes that I did to match the Java source names and
fixes to the DFA transitions. This is antlr-3.4.1.jar.


