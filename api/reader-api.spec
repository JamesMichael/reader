Name:		reader-api
Version:	0.1
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


%changelog
* Fri Jul 14 2013 <James Michael> - 0.1-1
- Initial api package
