Name:		reader-model
Version:	0.2
Release:	1%{?dist}
Summary:	Reader database code

Group:		Applications/Internet
License:	Public Domain
URL:		https://github.com/JamesMichael/reader
Source0:	%{name}-%{version}-%{release}.tar.gz
BuildRoot:	%(mktemp -ud %{_tmppath}/%{name}-%{version}-%{release}-XXXXXX)
BuildArch:	noarch

Requires:	perl(DBIx::Class)
Requires:	perl(Readonly)

%description
Database model code for reader


%prep
%setup -q -n model


%build
#%%configure


%install
rm -rf %{buildroot}

# perl modules
find lib -type d -print0 \
    | xargs -0 -I@ install -m 0755 -d %{buildroot}/opt/reader/@

find lib -type f -name '*.pm' -print0 \
    | xargs -0 -I@ install -m 0644 @ %{buildroot}/opt/reader/@

# schema files
install -m 0755 -d %{buildroot}/opt/reader/db
install -m 0644 db/* %{buildroot}/opt/reader/db

%clean
rm -rf %{buildroot}


%files
%defattr(-,reader,reader,-)

# perl modules
/opt/reader/lib/Reader/Model.pm
/opt/reader/lib/Reader/Model/Result/Feed.pm
/opt/reader/lib/Reader/Model/Result/Fetch.pm
/opt/reader/lib/Reader/Model/Result/Item.pm
/opt/reader/lib/Reader/Model/Result/State.pm

# schema files
/opt/reader/db/feed.sql
/opt/reader/db/fetch.sql
/opt/reader/db/item.sql
/opt/reader/db/state.sql

%changelog
* Thu Jul 27 2013 <James Michael> - 0.2-1
- Install schema files

* Fri Jul 14 2013 <James Michael> - 0.1-1
- Initial model package
