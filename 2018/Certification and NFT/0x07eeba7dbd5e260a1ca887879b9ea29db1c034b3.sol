['pragma solidity ^0.4.17;\n', '\n', 'contract Owned {\n', '   address public owner;\n', '   address public newOwner;\n', '\n', '   /**\n', '    * Events\n', '    */\n', '   event ChangedOwner(address indexed new_owner);\n', '\n', '   /**\n', '    * Functionality\n', '    */\n', '\n', '   function Owned() {\n', '       owner = msg.sender;\n', '   }\n', '\n', '   modifier onlyOwner() {\n', '       require(msg.sender == owner);\n', '       _;\n', '   }\n', '\n', '   function changeOwner(address _newOwner) onlyOwner external {\n', '       newOwner = _newOwner;\n', '   }\n', '\n', '   function acceptOwnership() external {\n', '       if (msg.sender == newOwner) {\n', '           owner = newOwner;\n', '           newOwner = 0x0;\n', '           ChangedOwner(owner);\n', '       }\n', '   }\n', '}\n', '\n', 'contract IOwned {\n', '   function owner() returns (address);\n', '   function changeOwner(address);\n', '   function acceptOwnership();\n', '}\n', '\n', '// interface with what we need to withdraw\n', 'contract Withdrawable {\n', '       function withdrawTo(address) returns (bool);\n', '}\n', '\n', '// responsible for\n', 'contract Distributor is Owned {\n', '\n', '       uint256 public nonce;\n', '       Withdrawable public w;\n', '\n', '       event BatchComplete(uint256 nonce);\n', '\n', '       event Complete();\n', '\n', '       function setWithdrawable(address w_addr) onlyOwner {\n', '               w = Withdrawable(w_addr);\n', '       }\n', '\n', '       function distribute(address[] addrs) onlyOwner {\n', '               for (uint256 i = 0; i <  addrs.length; i++) {\n', '                       w.withdrawTo(addrs[i]);\n', '               }\n', '               BatchComplete(nonce);\n', '               nonce = nonce + 1;\n', '       }\n', '\n', '       function complete() onlyOwner {\n', '               nonce = 0;\n', '               Complete();\n', '       }\n', '}']