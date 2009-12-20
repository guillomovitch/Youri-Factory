#!/usr/bin/perl
# $Id: test.t 1579 2007-03-22 13:29:57Z guillomovitch $

use strict;
use Test::More tests => 22;
use Test::Exception;
use Youri::Factory;

throws_ok {
    Youri::Factory->create()
} qr/^0 parameters were passed/,
'no first parameter';

throws_ok {
    Youri::Factory->create(undef)
} qr/^Parameter #1.*did not pass the '[^']+' callback/,
'first parameter is undefined';

throws_ok {
    Youri::Factory->create('foo')
} qr/^Parameter #1.*did not pass the '[^']+' callback/,
'first parameter is a not a class name';

throws_ok {
    Youri::Factory->create('IO::Handle')
} qr/^1 parameter was passed/,
'no second parameter';

throws_ok {
    Youri::Factory->create('IO::Handle', undef)
} qr/^Parameter #2.*did not pass the '[^']+' callback/,
'second parameter is undefined';

throws_ok {
    Youri::Factory->create('IO::Handle', 'foo')
} qr/^Parameter #2.*did not pass the '[^']+' callback/,
'second parameter is a not a class name';

throws_ok {
    Youri::Factory->create('IO::Handle', 'Test::More')
} qr/^Test::More is not a subclass of IO::Handle/,
'second parameter is not a subclass of the first parameter';

lives_ok {
    Youri::Factory->create('IO::Handle', 'IO::File')
} 'second parameter is a subclass of the first parameter';

throws_ok {
    Youri::Factory->create('IO::Handle', 'IO::File', undef)
} qr/^Parameter #3.*did not pass the '[^']+' callback/,
'third parameter is undefined';

throws_ok {
    Youri::Factory->create('IO::Handle', 'IO::File', 'foo')
} qr/^Parameter #3.*did not pass the '[^']+' callback/,
'third parameter is not an hashref';

lives_ok {
    Youri::Factory->create('IO::Handle', 'IO::File', {} )
} 'third parameter is an hashref';

throws_ok {
    Youri::Factory->create_from_configuration()
} qr/^0 parameters were passed/,
'no first parameter';

throws_ok {
    Youri::Factory->create_from_configuration(undef)
} qr/^Parameter #1.*did not pass the '[^']+' callback/,
'first parameter is undefined';

throws_ok {
    Youri::Factory->create_from_configuration('foo')
} qr/^Parameter #1.*did not pass the '[^']+' callback/,
'first parameter is a not a class name';

throws_ok {
    Youri::Factory->create_from_configuration('IO::Handle')
} qr/^1 parameter was passed/,
'no second parameter';

throws_ok {
    Youri::Factory->create_from_configuration('IO::Handle', undef)
} qr/^Parameter #2.*did not pass the '[^']+' callback/,
'second parameter is undefined';

throws_ok {
    Youri::Factory->create_from_configuration('IO::Handle', 'foo')
} qr/^Parameter #2.*did not pass the '[^']+' callback/,
'second parameter is a not an hashref';

throws_ok {
    Youri::Factory->create_from_configuration('IO::Handle', {})
} qr/^config hashref does not have a 'class' key/,
'second parameter does not have a class key';

lives_ok {
    Youri::Factory->create_from_configuration(
        'IO::Handle', { class => 'IO::File' }
    )
} 'second parameter has a class key';

throws_ok {
    Youri::Factory->create_from_configuration(
        'IO::Handle', { class => 'IO::File' }, undef
    )
} qr/^Parameter #3.*did not pass the '[^']+' callback/,
'third parameter is undefined';

throws_ok {
    Youri::Factory->create_from_configuration(
        'IO::Handle', { class => 'IO::File' }, 'foo'
    )
} qr/^Parameter #3.*did not pass the '[^']+' callback/,
'third parameter is not an hashref';

lives_ok {
    Youri::Factory->create_from_configuration(
        'IO::Handle', { class => 'IO::File' }, {}
    )
} 'third parameter is an hashref';
