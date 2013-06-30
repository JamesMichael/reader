Name:		reader-www
Version:	0.2
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

find htdocs -type d -print0 \
    | xargs -0 -I@ install -m 0755 -d %{buildroot}/vhosts/reader/@

find htdocs -type f -print0 \
    | xargs -0 -I@ install -m 0644 @ %{buildroot}/vhosts/reader/@


%clean
rm -rf %{buildroot}


%files
%defattr(-,nginx,nginx,-)

%attr(-,root,root) /vhosts/reader/etc/reader.conf

/vhosts/reader/htdocs/index.html
/vhosts/reader/htdocs/scripts/api.js
/vhosts/reader/htdocs/scripts/ui.js
/vhosts/reader/htdocs/style/reader.css


%changelog
* Wed Jul 26 2013 <James Michael> - 0.2-1
- Use HTTP basic authentication

* Fri Jul 14 2013 <James Michael> - 0.1-1
- Initial www package
