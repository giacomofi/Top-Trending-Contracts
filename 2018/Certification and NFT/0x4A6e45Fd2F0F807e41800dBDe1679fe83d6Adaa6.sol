['pragma solidity ^0.4.18;\n', '\n', '// ----------------------------------------------------------------------------\n', '// Owned - Ownership model with 2 phase transfers\n', '// Enuma Blockchain Platform\n', '//\n', '// Copyright (c) 2017 Enuma Technologies.\n', '// https://www.enuma.io/\n', '// ----------------------------------------------------------------------------\n', '\n', '\n', '// Implements a simple ownership model with 2-phase transfer.\n', 'contract Owned {\n', '\n', '   address public owner;\n', '   address public proposedOwner;\n', '\n', '   event OwnershipTransferInitiated(address indexed _proposedOwner);\n', '   event OwnershipTransferCompleted(address indexed _newOwner);\n', '\n', '\n', '   function Owned() public\n', '   {\n', '      owner = msg.sender;\n', '   }\n', '\n', '\n', '   modifier onlyOwner() {\n', '      require(isOwner(msg.sender) == true);\n', '      _;\n', '   }\n', '\n', '\n', '   function isOwner(address _address) public view returns (bool) {\n', '      return (_address == owner);\n', '   }\n', '\n', '\n', '   function initiateOwnershipTransfer(address _proposedOwner) public onlyOwner returns (bool) {\n', '      require(_proposedOwner != address(0));\n', '      require(_proposedOwner != address(this));\n', '      require(_proposedOwner != owner);\n', '\n', '      proposedOwner = _proposedOwner;\n', '\n', '      OwnershipTransferInitiated(proposedOwner);\n', '\n', '      return true;\n', '   }\n', '\n', '\n', '   function completeOwnershipTransfer() public returns (bool) {\n', '      require(msg.sender == proposedOwner);\n', '\n', '      owner = msg.sender;\n', '      proposedOwner = address(0);\n', '\n', '      OwnershipTransferCompleted(owner);\n', '\n', '      return true;\n', '   }\n', '}\n', '\n', '// ----------------------------------------------------------------------------\n', '// Math - General Math Utility Library\n', '// Enuma Blockchain Platform\n', '//\n', '// Copyright (c) 2017 Enuma Technologies.\n', '// https://www.enuma.io/\n', '// ----------------------------------------------------------------------------\n', '\n', '\n', 'library Math {\n', '\n', '   function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '      uint256 r = a + b;\n', '\n', '      require(r >= a);\n', '\n', '      return r;\n', '   }\n', '\n', '\n', '   function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '      require(a >= b);\n', '\n', '      return a - b;\n', '   }\n', '\n', '\n', '   function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '      if (a == 0) {\n', '         return 0;\n', '      }\n', '\n', '      uint256 r = a * b;\n', '\n', '      require(r / a == b);\n', '\n', '      return r;\n', '   }\n', '\n', '\n', '   function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '      return a / b;\n', '   }\n', '}\n', '\n', '// ----------------------------------------------------------------------------\n', '// ERC20Interface - Standard ERC20 Interface Definition\n', '// Enuma Blockchain Platform\n', '//\n', '// Copyright (c) 2017 Enuma Technologies.\n', '// https://www.enuma.io/\n', '// ----------------------------------------------------------------------------\n', '\n', '// ----------------------------------------------------------------------------\n', '// Based on the final ERC20 specification at:\n', '// https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md\n', '// ----------------------------------------------------------------------------\n', 'contract ERC20Interface {\n', '\n', '   event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '   event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '\n', '   function name() public view returns (string);\n', '   function symbol() public view returns (string);\n', '   function decimals() public view returns (uint8);\n', '   function totalSupply() public view returns (uint256);\n', '\n', '   function balanceOf(address _owner) public view returns (uint256 balance);\n', '   function allowance(address _owner, address _spender) public view returns (uint256 remaining);\n', '\n', '   function transfer(address _to, uint256 _value) public returns (bool success);\n', '   function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);\n', '   function approve(address _spender, uint256 _value) public returns (bool success);\n', '}\n', '\n', '// ----------------------------------------------------------------------------\n', '// ERC20Batch - Contract to help batching ERC20 operations.\n', '// Enuma Blockchain Platform\n', '//\n', '// Copyright (c) 2017 Enuma Technologies.\n', '// https://www.enuma.io/\n', '// ----------------------------------------------------------------------------\n', '\n', '\n', 'contract ERC20Batch is Owned {\n', '\n', '   using Math for uint256;\n', '\n', '   ERC20Interface public token;\n', '   address public tokenHolder;\n', '\n', '\n', '   event TransferFromBatchCompleted(uint256 _batchSize);\n', '\n', '\n', '   function ERC20Batch(address _token, address _tokenHolder) public\n', '      Owned()\n', '   {\n', '      require(_token != address(0));\n', '      require(_tokenHolder != address(0));\n', '\n', '      token = ERC20Interface(_token);\n', '      tokenHolder = _tokenHolder;\n', '   }\n', '\n', '\n', '   function transferFromBatch(address[] _toArray, uint256[] _valueArray) public onlyOwner returns (bool success) {\n', '      require(_toArray.length == _valueArray.length);\n', '      require(_toArray.length > 0);\n', '\n', '      for (uint256 i = 0; i < _toArray.length; i++) {\n', '         require(token.transferFrom(tokenHolder, _toArray[i], _valueArray[i]));\n', '      }\n', '\n', '      TransferFromBatchCompleted(_toArray.length);\n', '\n', '      return true;\n', '   }\n', '}']