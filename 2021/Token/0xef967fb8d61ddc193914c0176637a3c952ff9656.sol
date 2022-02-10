['/**\n', ' *Submitted for verification at Etherscan.io on 2021-05-28\n', '*/\n', '\n', '// pseudo-random number generator\n', '//SPDX-License-Identifier: LOL™®©\n', 'pragma solidity ^0.6.6;\n', 'contract PRNG {\n', ' uint randNonce = 0;\n', ' function randMod(uint _modulus) internal returns(uint) {\n', '  randNonce++;  \n', '  return uint(keccak256(abi.encodePacked(now, msg.sender, randNonce))) % _modulus;\n', ' }\n', '}']