/*
 * Key server protocol definition
 * Copyright (c) 2010, Oracle America, Inc.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are
 * met:
 *
 *     * Redistributions of source code must retain the above copyright
 *       notice, this list of conditions and the following disclaimer.
 *     * Redistributions in binary form must reproduce the above
 *       copyright notice, this list of conditions and the following
 *       disclaimer in the documentation and/or other materials
 *       provided with the distribution.
 *     * Neither the name of the "Oracle America, Inc." nor the names of its
 *       contributors may be used to endorse or promote products derived
 *       from this software without specific prior written permission.
 *
 *   THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 *   "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 *   LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 *   FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
 *   COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
 *   INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 *   DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE
 *   GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 *   INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
 *   WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
 *   NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 *   OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 * The keyserver is a public key storage/encryption/decryption service
 * The encryption method used is based on the Diffie-Hellman exponential
 * key exchange technology.
 *
 * The key server is local to each machine, akin to the portmapper.
 * Under TI-RPC, communication with the keyserver is through the
 * loopback transport.
 *
 * NOTE: This .x file generates the USER level headers for the keyserver.
 * the KERNEL level headers are created by hand as they kernel has special
 * requirements.
 */

%#if 0
%#pragma ident	"@(#)key_prot.x	1.7	94/04/29 SMI"
%#endif
%
%/* Copyright (c)  1990, 1991 Sun Microsystems, Inc. */
%
%/*
% * Compiled from key_prot.x using rpcgen.
% * DO NOT EDIT THIS FILE!
% * This is NOT source code!
% */

/*
 * PROOT and MODULUS define the way the Diffie-Hellman key is generated.
 *
 * MODULUS should be chosen as a prime of the form: MODULUS == 2*p + 1,
 * where p is also prime.
 *
 * PROOT satisfies the following two conditions:
 * (1) (PROOT ** 2) % MODULUS != 1
 * (2) (PROOT ** p) % MODULUS != 1
 *
 */

const PROOT = 3;
const HEXMODULUS = "d4a0ba0250b6fd2ec626e7efd637df76c716e22d0944b88b";

const HEXKEYBYTES = 48;		/* HEXKEYBYTES == strlen(HEXMODULUS) */
const KEYSIZE = 192;		/* KEYSIZE == bit length of key */
const KEYBYTES = 24;		/* byte length of key */

/*
 * The first 16 hex digits of the encrypted secret key are used as
 * a checksum in the database.
 */
const KEYCHECKSUMSIZE = 16;

/*
 * status of operation
 */
enum keystatus {
	KEY_SUCCESS,	/* no problems */
	KEY_NOSECRET,	/* no secret key stored */
	KEY_UNKNOWN,	/* unknown netname */
	KEY_SYSTEMERR 	/* system error (out of memory, encryption failure) */
};

typedef opaque keybuf[HEXKEYBYTES];	/* store key in hex */

typedef string netnamestr<MAXNETNAMELEN>;

/*
 * Argument to ENCRYPT or DECRYPT
 */
struct cryptkeyarg {
	netnamestr remotename;
	des_block deskey;
};

/*
 * Argument to ENCRYPT_PK or DECRYPT_PK
 */
struct cryptkeyarg2 {
	netnamestr remotename;
	netobj	remotekey;	/* Contains a length up to 1024 bytes */
	des_block deskey;
};


/*
 * Result of ENCRYPT, DECRYPT, ENCRYPT_PK, and DECRYPT_PK
 */
union cryptkeyres switch (keystatus status) {
case KEY_SUCCESS:
	des_block deskey;
default:
	void;
};

const MAXGIDS  = 16;	/* max number of gids in gid list */

/*
 * Unix credential
 */
struct unixcred {
	u_int uid;
	u_int gid;
	u_int gids<MAXGIDS>;
};

/*
 * Result returned from GETCRED
 */
union getcredres switch (keystatus status) {
case KEY_SUCCESS:
	unixcred cred;
default:
	void;
};
/*
 * key_netstarg;
 */

struct key_netstarg {
	keybuf st_priv_key;
	keybuf st_pub_key;
	netnamestr st_netname;
};

union key_netstres switch (keystatus status){
case KEY_SUCCESS:
	key_netstarg knet;
default:
	void;
};

#ifdef RPC_HDR
%
%#ifndef opaque
%#define opaque char
%#endif
%
#endif
program KEY_PROG {
	version KEY_VERS {

		/*
		 * This is my secret key.
	 	 * Store it for me.
		 */
		keystatus
		KEY_SET(keybuf) = 1;

		/*
		 * I want to talk to X.
		 * Encrypt a conversation key for me.
	 	 */
		cryptkeyres
		KEY_ENCRYPT(cryptkeyarg) = 2;

		/*
		 * X just sent me a message.
		 * Decrypt the conversation key for me.
		 */
		cryptkeyres
		KEY_DECRYPT(cryptkeyarg) = 3;

		/*
		 * Generate a secure conversation key for me
		 */
		des_block
		KEY_GEN(void) = 4;

		/*
		 * Get me the uid, gid and group-access-list associated
		 * with this netname (for kernel which cannot use NIS)
		 */
		getcredres
		KEY_GETCRED(netnamestr) = 5;
	} = 1;
	version KEY_VERS2 {

		/*
		 * #######
		 * Procedures 1-5 are identical to version 1
		 * #######
		 */

		/*
		 * This is my secret key.
	 	 * Store it for me.
		 */
		keystatus
		KEY_SET(keybuf) = 1;

		/*
		 * I want to talk to X.
		 * Encrypt a conversation key for me.
	 	 */
		cryptkeyres
		KEY_ENCRYPT(cryptkeyarg) = 2;

		/*
		 * X just sent me a message.
		 * Decrypt the conversation key for me.
		 */
		cryptkeyres
		KEY_DECRYPT(cryptkeyarg) = 3;

		/*
		 * Generate a secure conversation key for me
		 */
		des_block
		KEY_GEN(void) = 4;

		/*
		 * Get me the uid, gid and group-access-list associated
		 * with this netname (for kernel which cannot use NIS)
		 */
		getcredres
		KEY_GETCRED(netnamestr) = 5;

		/*
		 * I want to talk to X. and I know X's public key
		 * Encrypt a conversation key for me.
	 	 */
		cryptkeyres
		KEY_ENCRYPT_PK(cryptkeyarg2) = 6;

		/*
		 * X just sent me a message. and I know X's public key
		 * Decrypt the conversation key for me.
		 */
		cryptkeyres
		KEY_DECRYPT_PK(cryptkeyarg2) = 7;

		/*
		 * Store my public key, netname and private key.
		 */
		keystatus
		KEY_NET_PUT(key_netstarg) = 8;

		/*
		 * Retrieve my public key, netname and private key.
		 */
 		key_netstres
		KEY_NET_GET(void) = 9;

		/*
		 * Return me the conversation key that is constructed
		 * from my secret key and this publickey.
		 */

		cryptkeyres
		KEY_GET_CONV(keybuf) = 10;


	} = 2;
} = 100029;
