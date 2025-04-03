# This Puppet script automates the fix for Apache 500 errors by ensuring Apache is installed, running,
# and has the correct directory permissions and necessary modules enabled.

class apache_fix {
    package { 'apache2':
        ensure => installed,
    }

    service { 'apache2':
        ensure  => running,
        enable  => true,
        require => Package['apache2'],
    }

    # Ensure Apache's root directory has correct permissions
    file { '/var/www/html':
        ensure  => directory,
        owner   => 'www-data',
        group   => 'www-data',
        mode    => '0755',
    }

    # Fix missing modules (example: mod_rewrite)
    exec { 'enable_mod_rewrite':
        command => '/usr/sbin/a2enmod rewrite && systemctl restart apache2',
        unless  => '/usr/sbin/apachectl -M | grep rewrite_module',
        require => Service['apache2'],
    }
}

# Include the apache_fix class directly (without needing autoload module structure)
include apache_fix

