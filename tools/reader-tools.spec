Name:		reader-tools
Version:	0.3
Release:	1%{?dist}
Summary:	Reader Tools

Group:		Applications/Internet
License:	Public Domain
URL:		https://github.com/JamesMichael/reader
Source0:	%{name}-%{version}-%{release}.tar.gz
BuildRoot:	%(mktemp -ud %{_tmppath}/%{name}-%{version}-%{release}-XXXXXX)
BuildArch:	noarch

Requires:	perl(File::Pid)
Requires:	perl(Readonly)
Requires:	perl(XML::XPath)
Requires:	perl(Term::ReadKey)
Requires:	perl(File::Slurp)

%description
Misc. tools


%prep
%setup -q -n tools


%build
#%%configure


%install
rm -rf %{buildroot}

install -m 0755 -d %{buildroot}/opt/reader/bin/
install -m 0755 bin/* %{buildroot}/opt/reader/bin

# misc directories required by various scripts
install -m 0755 -d %{buildroot}/opt/reader/var/lock
install -m 0755 -d %{buildroot}/opt/reader/var/log
install -m 0755 -d %{buildroot}/opt/reader/var/run


%clean
rm -rf %{buildroot}


%files
%defattr(-,reader,reader,-)

/opt/reader/bin/build
/opt/reader/bin/greader_import
/opt/reader/bin/htpasswd_gen
/opt/reader/bin/run
/opt/reader/bin/setup_database

/opt/reader/var/lock
/opt/reader/var/log
/opt/reader/var/run


%changelog
* Thu Jul 27 2013 <James Michael> - 0.3-1
- Build /opt/reader/var directories

* Wed Jul 26 2013 <James Michael> - 0.2-1
- Add script to generate htpasswd files

* Mon Jul 24 2013 <James Michael> - 0.1-1
- Initial tools package
