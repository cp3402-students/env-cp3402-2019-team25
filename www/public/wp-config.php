<?php
/**
 * The base configuration for WordPress
 *
 * The wp-config.php creation script uses this file during the
 * installation. You don't have to use the web site, you can
 * copy this file to "wp-config.php" and fill in the values.
 *
 * This file contains the following configurations:
 *
 * * MySQL settings
 * * Secret keys
 * * Database table prefix
 * * ABSPATH
 *
 * @link https://codex.wordpress.org/Editing_wp-config.php
 *
 * @package WordPress
 */

// ** MySQL settings - You can get this info from your web host ** //
/** The name of the database for WordPress */
define( 'DB_NAME', 'scotchbox' );

/** MySQL database username */
define( 'DB_USER', 'WebAdmin' );

/** MySQL database password */
define( 'DB_PASSWORD', 'gG5XCvUSL4keOwamsEz' );

/** MySQL hostname */
define( 'DB_HOST', 'localhost' );

/** Database Charset to use in creating database tables. */
define( 'DB_CHARSET', 'utf8mb4' );

/** The Database Collate type. Don't change this if in doubt. */
define( 'DB_COLLATE', '' );

/**#@+
 * Authentication Unique Keys and Salts.
 *
 * Change these to different unique phrases!
 * You can generate these using the {@link https://api.wordpress.org/secret-key/1.1/salt/ WordPress.org secret-key service}
 * You can change these at any point in time to invalidate all existing cookies. This will force all users to have to log in again.
 *
 * @since 2.6.0
 */
define( 'AUTH_KEY',         '*/=A?]Bwc/@cd2zg8Q:8?=X[}wX[]]02%(a/!1E1!;Nne@t@vk`Rrua^bz;,v)A{' );
define( 'SECURE_AUTH_KEY',  '1kDil9 fMCaUUw%61w56be1WY[-Od(LLLgOkOo{jTqpqwpQx(E-pElt@SNx=D:}=' );
define( 'LOGGED_IN_KEY',    '^C0nU5{{!+p8(@R&(Kb5+lho>2t/T5on!un+{Wa70|NC}W^}I^|d{=mQ66},LQ*`' );
define( 'NONCE_KEY',        'NqpNqcY:_ZdyA/;nVPGbpw$zq;wgtU^YXVTHxJ6G[wAaxU~f49NIKd$DnMf;ZM%7' );
define( 'AUTH_SALT',        'rJ2GmI=0VGjxPGj}AL4o$}9^6>1[|)LK&fM}%^bq<,iYpVltV*doa?]F|YZy+9Jb' );
define( 'SECURE_AUTH_SALT', 'n,[Q -3-k8$VV8r!Ky3B<{0FsVNnYX=^s^NLZ@;jv=iP6*ma_Qhg]z|1(HHr$~Q:' );
define( 'LOGGED_IN_SALT',   'Io~<;T<KCw;m]NL*%Y=+(^:RX#(-(gO``]e, nY6,vl8fl[97A ,qz$,dE%3i+q,' );
define( 'NONCE_SALT',       'a:[2bB/XJ&*D^]843/*srDV5#Ny~qrsW#s8]&>&V<ux=dPo?rB?W7PE|?-d%)89%' );

/**#@-*/

/**
 * WordPress Database Table prefix.
 *
 * You can have multiple installations in one database if you give each
 * a unique prefix. Only numbers, letters, and underscores please!
 */
$table_prefix = 'wp_';

/**
 * For developers: WordPress debugging mode.
 *
 * Change this to true to enable the display of notices during development.
 * It is strongly recommended that plugin and theme developers use WP_DEBUG
 * in their development environments.
 *
 * For information on other constants that can be used for debugging,
 * visit the Codex.
 *
 * @link https://codex.wordpress.org/Debugging_in_WordPress
 */
define( 'WP_DEBUG', false );

/* That's all, stop editing! Happy publishing. */

/** Absolute path to the WordPress directory. */
if ( ! defined( 'ABSPATH' ) ) {
	define( 'ABSPATH', dirname( __FILE__ ) . '/' );
}

/** Sets up WordPress vars and included files. */
require_once( ABSPATH . 'wp-settings.php' );
