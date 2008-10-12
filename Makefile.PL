# $Id: Makefile.PL 1599 2007-03-23 08:47:27Z guillomovitch $
use ExtUtils::MakeMaker;
use version;

WriteMakefile(
    NAME         => 'Youri::Factory',
    VERSION_FROM => 'lib/Youri/Factory.pm',
    AUTHOR       => 'Youri project <youri@zarb.org>',
    PREREQ_PM    => {
        'UNIVERSAL::require' => 0,
        'Youri::Error'       => 0,
        'version'            => 0,
    }
);

sub MY::postamble {
   return <<'EOF';
.PHONY: svntag
SVNPATH = svn+ssh://youri.zarb.org/home/projects/youri/svn/soft/Factory

svntag:
	svn copy -m 'new release $(VERSION)'\
		$(SVNPATH)/trunk \
		$(SVNPATH)/tags/release-$(VERSION)

EOF
}
