['pragma solidity ^0.4.10;\n', '\n', 'contract balancesImporter4    {\n', '\n', 'address[] public addresses4;\n', 'uint256[] public balances4;\n', '\n', 'function balancesImporter4()    {\n', '\n', 'addresses4=[0x81933df2b25d6303ff24256686678c2afe8a8e7b\n', ',0xb13432cd2e16bee58a6d4bca5fd522a629a0234e\n', ',0x2db3227571dd7aee8f50aec01a77f6aa96b8fd3d\n', ',0x1ef98700759ed8eefbbdc2b2d05c88c515da57f4\n', ',0x1233bf6fb2a2230d75e26f3dfe7d394a2ad770eb\n', ',0x21bc7280773f12fe7e8978d64f9b737cfa53e587\n', ',0x71f1c0abb131f409a852d2a2d1b52db710577ff7\n', ',0xce23fbc3bea128c6fb3f9cc24a6582da0dd0b723\n', ',0xb2f535b7c216a0c8494648df3048d94b64f1c82c\n', ',0x67035a34bf04bb881c517c12f8714914b84fde57\n', ',0x88ac921241ac052efa9eb34f0de3f5a2da23f037\n', ',0x4b326c1865806209846195a48d96ebbdb33e0754\n', ',0x4bc8484426b7437e275986ee435a5447eaf9ed2b\n', ',0x32394d13f995198b820e804c443d778f8a3c625b\n', ',0x8d3682d3f372c8e506320f2c7103cae207af3755\n', ',0xfa1c1ea538c9b44a03fa68dd4b7e23b2f964d205\n', ',0x5df26f2af73ddc01c14c94052981ffcd9149ea11\n', ',0x8bd37c2b6e820f67a236fa44d958222c87de5fcd\n', ',0xfd185d3020384d9eac2dfcff821727d0a4f9e51e\n', ',0xdde1964cddfc9df2ae93bdf1cadc3fe7cca79fc6\n', ',0x88d662ae24d970c11ac70874545be4cce4f1b932\n', ',0xcc74370181ca10222b76816eee31f48a3da9edb5\n', ',0x1d8179abeb15560a5d43924058ce841a0f6f1e18\n', ',0x0f80ce42ee1561586ce42bd3cb04ebcdb0dbcfa3\n', ',0x9805cae2a4aeba47b766b2e20b459bc26c74471a\n', ',0xf13a4dd289b5f208ed25b199a3452082335023d0\n', ',0xad6565066590f6cb6117e2e78c8116c620c906ed\n', ',0x6154c21d76c9ed1fdea64763182bbc9f326d176d\n', ',0x8f26c40e71bb6533089d66590d93590499d3a895\n', ',0x1403045b3d31d3842728a81240d69bdc3da8e7a2\n', ',0x1d2783c714405116da976e2da5f3d0a236a78dac\n', ',0x7794c91f732028329cdf153140848ade0c504b2b\n', ',0x0ad3126f17d1b0a6adf4f509636e4e47b5217d8c\n', ',0xa86b0689e07482b3f797860c59bef2a377d23743\n', ',0xd7453443dba65991e2e7562aa1d5518500f86678\n', ',0xb3d9f2a37dcbb22301db0d89439ab09284cd9ed8\n', ',0x9ce4f7fc8782411285a0c11ef6e54dbca5f3e130\n', ',0x5bfaf1fdaf9c68ae06beaf4c5facb7f366577c5d\n', ',0xf54b4772efd5b5b5703943c3eb78c2e6ae135d13\n', ',0xdc3c308610fb4e76820e1e2b8bf6d7ec856bf7c9\n', ',0x33456714fd42bd1d01eedc2c0d7f64d5cc0b8564\n', ',0xee6e802c7395caec8caa79583b2328667836c365\n', ',0xe4537b2a98e80c20262eb209ee35490ec3d54f03\n', ',0x0070f86ce1321a763cb7a248c2eba58e184183cb\n', ',0x91c3b4ef468e38add38d398eb7953baaf42bc0a9\n', ',0x1cda869c6732e1b557211229a03a3a54fc73327a\n', ',0x9167c9ebb009f0b0b1fee5d3b72591a0068ec25a\n', ',0x11dd34d7a815077104138af351e4f9caf73d623b\n', ',0x667f9ab6c1aaf43ba78244eb46677ac94c436631\n', ',0xe902b4561d6a5258161fc0a835b2dde54f4ec1aa\n', ',0x7962d8cce79fac85098862db571d783dd6e8d796\n', ',0xe8d8cd0b5c995a02f2710a30cf3370da13f7de18\n', ',0x95c707430b7c9c8efb10c3bc693c1b2b480e48be\n', ',0xbcac7e0c34b4d2a032a1bafc1f74aff1d8d020d1\n', ',0xade4554dcd8385672a26e89388ae2f4edcca8051\n', ',0x07c36f2ab14e16a4435151c91215311a733438c7\n', ',0x2a02904c2d7510a28d184387aab187478182a60b\n', ',0x556c412d391c75bd12d97c2cacff3caa3793ee4a\n', ',0xa80d162e3d6ec4efdc6fda789b9203698b48c72c\n', ',0x842355e51a62a7b75269d0f4e31d4565b1efab8b\n', ',0x9461a14ae7d557256284cd8df22d8d2817860188\n', ',0xfba17024697a7a0070ca2fb2c0ff2d23480d649d\n', ',0xbcfbe02ccf0112b69c28a506834b593e131499a6\n', ',0xe43b5c7fa0149340cd5905eec06d5d3f767bc7f4\n', ',0x1828068e072d945cdcc4628b1e7f3c25a108ce0f\n', ',0x9c6b830f2db73ddb2a62e5ab2692b76f1d07d18a\n', ',0x3f864fe96e2c4a308ff523b976129cb920cf0d6d\n', ',0x398e6822b0a18ca057d6604a1262f5c8ab138103\n', ',0xf31bb5d05b36030b1ceac11f42b1f24447ed4486\n', ',0x77b2ab6ea66965ef1cb7138142c07f1a03ae76b3\n', '];\n', '\n', 'balances4=[1000000000000000000\n', ',1000000000000000000\n', ',1000000000000000000\n', ',1100000000000000128\n', ',1000000000000000000\n', ',1000000000000000000\n', ',1000000000000000000\n', ',1000000000000000000\n', ',1000000000000000000\n', ',190000000000000\n', ',48729036870\n', ',650000000000000000\n', ',1000000000000000000\n', ',1000000000000000000\n', ',1000000000000000000\n', ',1000000000000000000\n', ',1000000000000000000\n', ',1000000000000000000\n', ',1000000000000000000\n', ',5087952616057829588992\n', ',1000000000000000000\n', ',265000000000000000\n', ',1000000000000000000\n', ',1000000000000000000\n', ',1000000000000000000\n', ',11000000000000000\n', ',1000000000000000000\n', ',1100000000000000128\n', ',1000000000000000000\n', ',1000000000000000000\n', ',1000000000000000000\n', ',1000000000000000000\n', ',969013984012679040\n', ',910000000000000000\n', ',1000000000000000000\n', ',1000000000000000000\n', ',1000000000000000000\n', ',1000000000000000000\n', ',1000000000000000000\n', ',1000000000000000000\n', ',1100000000000000128\n', ',1000000000000000000\n', ',1012283580667830144\n', ',1000000000000000000\n', ',1000000000000000000\n', ',1000000000000000000\n', ',1000000000000000000\n', ',15393082141999999483904\n', ',1000000000000000000\n', ',1000000000000000000\n', ',1000000000000000000\n', ',1000000000000000000\n', ',13758000000000000\n', ',10000000000000000000\n', ',10000000000000000000\n', ',1000000000000000000\n', ',12747616985350099959808\n', ',1000000000000000000\n', ',1000000000000000000\n', ',1000000000000000000\n', ',1000000000000000000\n', ',1000000000000000000\n', ',1632115677319299840\n', ',10150464684470000680960\n', ',1000000000000000000\n', ',10000000000000\n', ',1000000000000000000\n', ',1000000000000000000\n', ',1000000000000000000\n', ',1000000000000000000\n', '];\n', '\n', 'elixor elixorContract=elixor(0x898bf39cd67658bd63577fb00a2a3571daecbc53);\n', 'elixorContract.importAmountForAddresses(balances4,addresses4);\n', '\n', '}\n', '}\n', '\n', 'contract elixor  {\n', '\n', 'function importAmountForAddresses(uint256[] amounts,address[] addressesToAddTo);\n', '\n', '}']