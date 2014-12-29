Name:		reader-api
Version:	0.3
Release:	1%{?dist}
Summary:	Reader API server

Group:		Applications/Internet
License:	Public Domain
URL:		https://github.com/JamesMichael/reader
Source0:	%{name}-%{version}-%{release}.tar.gz
BuildRoot:	%(mktemp -ud %{_tmppath}/%{name}-%{version}-%{release}-XXXXXX)
BuildArch:	noarch

Requires:	perl(JSON)
Requires:	perl(URI)
Requires:	perl(Moose)
Requires:	perl(Readonly)
Requires:	perl(DBIx::Class)
Requires:	perl(HTTP::Message)
Requires: 	perl(Proc::Daemon)

Requires:	reader-model

%description
Server providing API access to reader.


%prep
%setup -q -n api


%build
#%%configure


%install
rm -rf %{buildroot}

install -m 0755 -d %{buildroot}/opt/reader/bin/
install -m 0755 bin/* %{buildroot}/opt/reader/bin

install -m 0755 -d %{buildroot}/etc/rc.d/init.d/
install -m 0755 etc/apid %{buildroot}/etc/rc.d/init.d/apid

find lib -type d -print0 \
    | xargs -0 -I@ install -m 0755 -d %{buildroot}/opt/reader/@

find lib -type f -name '*.pm' -print0 \
    | xargs -0 -I@ install -m 0644 @ %{buildroot}/opt/reader/@

%clean
rm -rf %{buildroot}


%files
%defattr(-,reader,reader,-)

/opt/reader/bin/api_server
/opt/reader/lib/Reader/API.pm
/opt/reader/lib/Reader/API/Format.pm
/opt/reader/lib/Reader/API/Format/JSON.pm
/opt/reader/lib/Reader/API/Handler.pm
/opt/reader/lib/Reader/API/Router.pm
/opt/reader/lib/Reader/API/Server.pm

%attr(-,root,root) /etc/rc.d/init.d/apid

%changelog
* Mon Dec 29 2014 <James Michael> - 0.3-1
- Add support for 'starred' item state

* Wed Jul 26 2013 <James Michael> - 0.2-2
- Add init script and daemonise server

* Fri Jul 14 2013 <James Michael> - 0.1-2
- Initial api package
