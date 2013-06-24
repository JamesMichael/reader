Name:		reader-tools
Version:	0.1
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


%clean
rm -rf %{buildroot}


%files
%defattr(-,reader,reader,-)

/opt/reader/bin/build
/opt/reader/bin/greader_import
/opt/reader/bin/run
/opt/reader/bin/setup_database


%changelog
* Mon Jul 24 2013 <James Michael> - 0.1-1
- Initial tools package
