Name:		reader-www
Version:	0.1
Release:	1%{?dist}
Summary:	Reader Web server files

Group:		Applications/Internet
License:	Public Domain
URL:		https://github.com/JamesMichael/reader
Source0:	%{name}-%{version}-%{release}.tar.gz
BuildRoot:	%(mktemp -ud %{_tmppath}/%{name}-%{version}-%{release}-XXXXXX)
BuildArch:  noarch

Requires:	nginx

%description
Webserver related files for reader.


%prep
%setup -q -n www


%build
#%%configure


%install
rm -rf %{buildroot}

install -m 0755 -d %{buildroot}/vhosts/reader/etc/
install -m 0644 etc/* %{buildroot}/vhosts/reader/etc/

install -m 0755 -d %{buildroot}/vhosts/reader/htdocs/
install -m 0644 htdocs/* %{buildroot}/vhosts/reader/htdocs/


%clean
rm -rf %{buildroot}


%files
%defattr(-,nginx,nginx,-)

%attr(-,root,root) /vhosts/reader/etc/reader.conf
/vhosts/reader/htdocs/index.html


%changelog
* Fri Jul 14 2013 <James Michael> - 0.1-1
- Initial www package
