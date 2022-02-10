['pragma solidity ^0.4.24;\n', '\n', 'contract ERC20 {\n', '  function balanceOf (address owner) public view returns (uint256);\n', '  function allowance (address owner, address spender) public view returns (uint256);\n', '  function transfer (address to, uint256 value) public returns (bool);\n', '  function transferFrom (address from, address to, uint256 value) public returns (bool);\n', '  function approve (address spender, uint256 value) public returns (bool);\n', '}\n', '\n', 'contract MiddleSaleService {\n', '\n', '  address public frontWindow;\n', '  address public salesPipe;\n', '  ERC20   public erc;\n', '  address public owner;\n', '\n', '  constructor(address _frontWindow, address _salesPipe, ERC20 _erc) public {\n', '    frontWindow = _frontWindow;\n', '    salesPipe = _salesPipe;\n', '    erc = _erc;\n', '    owner = msg.sender;\n', '  }\n', '\n', '  function setFrontWindow (address _frontWindow) external {\n', '    require(msg.sender == owner);\n', '    frontWindow = _frontWindow;\n', '  }\n', '\n', '  function setSalesPipe (address _salesPipe) external {\n', '    require(msg.sender == owner);\n', '    salesPipe = _salesPipe;\n', '  }\n', '\n', '  function setERC (ERC20 _erc) external {\n', '    require(msg.sender == owner);\n', '    erc = _erc;\n', '  }\n', '\n', '  function setOwner (address _owner) external {\n', '    require(msg.sender == owner);\n', '    owner = _owner;\n', '  }\n', '\n', '  function buyFST0 (address receiver) internal {\n', '    require(salesPipe.call.value(msg.value)());\n', '\n', '    uint256 tmpERCBalance = erc.balanceOf(address(this));\n', '    uint256 tmpEthBalance = address(this).balance;\n', '\n', '    if (tmpERCBalance > 0) {\n', '      require(erc.transfer(receiver, tmpERCBalance));\n', '    }\n', '\n', '    if (tmpEthBalance > 0) {\n', '      require(receiver.send(tmpEthBalance));\n', '    }\n', '  }\n', '\n', '  function buyFST (address receiver) public payable {\n', '    buyFST0(receiver);\n', '  }\n', '\n', '  function buyFST () public payable {\n', '    buyFST0(msg.sender);\n', '  }\n', '\n', '  function () external payable {\n', '    buyFST0(msg.sender);\n', '  }\n', '\n', '}']