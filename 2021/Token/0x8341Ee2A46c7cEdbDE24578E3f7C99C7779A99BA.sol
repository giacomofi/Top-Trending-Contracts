['/**\n', ' *Submitted for verification at Etherscan.io on 2021-06-09\n', '*/\n', '\n', '// File: @openzeppelin/contracts/token/ERC20/IERC20.sol\n', ' \n', 'pragma solidity ^0.8.0;\n', ' \n', '/**\n', ' * @dev Interface of the ERC20 standard as defined in the EIP.\n', ' */\n', 'interface IERC20 {\n', ' /**\n', ' * @dev Returns the amount of tokens in existence.\n', ' */\n', ' function totalSupply() external view returns (uint256);\n', ' \n', ' /**\n', ' * @dev Returns the amount of tokens owned by `account`.\n', ' */\n', ' function balanceOf(address account) external view returns (uint256);\n', ' \n', ' /**\n', " * @dev Moves `amount` tokens from the caller's account to `recipient`.\n", ' *\n', ' * Returns a boolean value indicating whether the operation succeeded.\n', ' *\n', ' * Emits a {Transfer} event.\n', ' */\n', ' function transfer(address recipient, uint256 amount) external returns (bool);\n', ' \n', ' /**\n', ' * @dev Returns the remaining number of tokens that `spender` will be\n', ' * allowed to spend on behalf of `owner` through {transferFrom}. This is\n', ' * zero by default.\n', ' *\n', ' * This value changes when {approve} or {transferFrom} are called.\n', ' */\n', ' function allowance(address owner, address spender) external view returns (uint256);\n', ' \n', ' /**\n', " * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.\n", ' *\n', ' * Returns a boolean value indicating whether the operation succeeded.\n', ' *\n', ' * IMPORTANT: Beware that changing an allowance with this method brings the risk\n', ' * that someone may use both the old and the new allowance by unfortunate\n', ' * transaction ordering. One possible solution to mitigate this race\n', " * condition is to first reduce the spender's allowance to 0 and set the\n", ' * desired value afterwards:\n', ' * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', ' *\n', ' * Emits an {Approval} event.\n', ' */\n', ' function approve(address spender, uint256 amount) external returns (bool);\n', ' \n', ' /**\n', ' * @dev Moves `amount` tokens from `sender` to `recipient` using the\n', " * allowance mechanism. `amount` is then deducted from the caller's\n", ' * allowance.\n', ' *\n', ' * Returns a boolean value indicating whether the operation succeeded.\n', ' *\n', ' * Emits a {Transfer} event.\n', ' */\n', ' function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\n', ' \n', ' /**\n', ' * @dev Emitted when `value` tokens are moved from one account (`from`) to\n', ' * another (`to`).\n', ' *\n', ' * Note that `value` may be zero.\n', ' */\n', ' event Transfer(address indexed from, address indexed to, uint256 value);\n', ' \n', ' /**\n', ' * @dev Emitted when the allowance of a `spender` for an `owner` is set by\n', ' * a call to {approve}. `value` is the new allowance.\n', ' */\n', ' event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', ' \n', '// File: contracts/EVAICollateral.sol\n', ' \n', '// SPDX-License-Identifier: MIT\n', ' \n', 'pragma solidity 0.8.3;\n', ' \n', '/// @title EvaiCollateral Contract\n', '/// @notice This contract is used to lock EVAI.IO ERC20 tokens as collateral for bridged BEP20 tokens on BSC\n', ' \n', 'contract EvaiCollateral {\n', ' IERC20 evaiETHToken;\n', ' address owner;\n', ' \n', ' mapping(address => mapping(bytes32 => bool)) public processedTransactions;\n', ' \n', ' event BrigeFromBEP20(uint256 _amount);\n', ' \n', ' constructor(address _token) {\n', ' evaiETHToken = IERC20(_token);\n', ' owner = msg.sender;\n', ' }\n', ' \n', ' function getLockedTokens() view public returns(uint256 lockedTokens) {\n', ' lockedTokens = evaiETHToken.balanceOf(address(this)); \n', ' }\n', ' \n', ' function bridgeFromBEP20 (bytes32 _txhash,address _from,uint256 tokens,uint256 nonce,bytes calldata signature) public {\n', ' require(msg.sender == owner,"EvaiCollateral: Caller is not owner");\n', ' require(tokens <= evaiETHToken.balanceOf(address(this)),"Not Enough Tokens");\n', ' bytes32 message = prefixed(keccak256(abi.encodePacked(\n', ' _txhash,_from,tokens,nonce)));\n', ' require(processedTransactions[msg.sender][_txhash] == false,"Transfer already processed");\n', ' require(recoverSigner(message,signature) == _from,"Wrong Address");\n', ' processedTransactions[msg.sender][_txhash] = true;\n', ' evaiETHToken.approve(address(this),tokens);\n', ' evaiETHToken.transferFrom(address(this), _from,tokens);\n', ' emit BrigeFromBEP20(tokens);\n', ' }\n', ' \n', ' function prefixed(bytes32 hash) internal pure returns (bytes32) {\n', ' return keccak256(abi.encodePacked(\n', " '\\x19Ethereum Signed Message:\\n32',hash\n", ' ));\n', ' }\n', ' \n', ' function recoverSigner(bytes32 message, bytes memory signature) internal pure returns(address) {\n', ' uint8 v;\n', ' bytes32 r;\n', ' bytes32 s;\n', ' \n', ' (v,r,s) = splitSignature(signature);\n', ' \n', ' return ecrecover(message,v,r,s);\n', ' \n', ' }\n', ' \n', ' function splitSignature(bytes memory signature) internal pure returns (uint8 v, bytes32 r, bytes32 s) {\n', ' require(signature.length == 65,"EVAICOLLATERAL: Length should be 65");\n', ' \n', ' //bytes32 r;\n', ' //bytes32 s;\n', ' //uint8 v;\n', ' \n', ' assembly {\n', ' // First 32 bytes, after the length prefix\n', ' r := mload(add(signature,32))\n', ' // second 32 Bytes\n', ' s := mload(add(signature,64))\n', ' //Final byte ( first byte of the next 32 bytes)\n', ' v := byte(0,mload(add(signature,96)))\n', ' }\n', ' \n', ' return(v,r,s);\n', ' }\n', ' \n', ' \n', ' \n', '}']