['pragma solidity ^0.4.24;\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address private _owner;\n', '\n', '  event OwnershipTransferred(\n', '    address indexed previousOwner,\n', '    address indexed newOwner\n', '  );\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  constructor() internal {\n', '    _owner = msg.sender;\n', '    emit OwnershipTransferred(address(0), _owner);\n', '  }\n', '\n', '  /**\n', '   * @return the address of the owner.\n', '   */\n', '  function owner() public view returns(address) {\n', '    return _owner;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(isOwner());\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @return true if `msg.sender` is the owner of the contract.\n', '   */\n', '  function isOwner() public view returns(bool) {\n', '    return msg.sender == _owner;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to relinquish control of the contract.\n', '   * @notice Renouncing to ownership will leave the contract without an owner.\n', '   * It will not be possible to call the functions with the `onlyOwner`\n', '   * modifier anymore.\n', '   */\n', '  function renounceOwnership() public onlyOwner {\n', '    emit OwnershipTransferred(_owner, address(0));\n', '    _owner = address(0);\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    _transferOwnership(newOwner);\n', '  }\n', '\n', '  /**\n', '   * @dev Transfers control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function _transferOwnership(address newOwner) internal {\n', '    require(newOwner != address(0));\n', '    emit OwnershipTransferred(_owner, newOwner);\n', '    _owner = newOwner;\n', '  }\n', '}\n', '\n', 'contract BCEOInterface {\n', '  function owner() public view returns (address);\n', '  function balanceOf(address who) public view returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '  \n', '}\n', '\n', '\n', 'contract TransferContract is Ownable {\n', '  address private addressBCEO; \n', '  address private addressABT; \n', '  \n', '  BCEOInterface private bCEOInstance;\n', '\n', '  function initTransferContract(address _addressBCEO) public onlyOwner returns (bool) {\n', '    require(_addressBCEO != address(0));\n', '    addressBCEO = _addressBCEO;\n', '    bCEOInstance = BCEOInterface(addressBCEO);\n', '    return true;\n', '  }\n', '\n', '  function batchTransfer (address sender, address[] _receivers,  uint256[] _amounts) public onlyOwner {\n', '    uint256 cnt = _receivers.length;\n', '    require(cnt > 0);\n', '    require(cnt == _amounts.length);\n', '    for ( uint i = 0 ; i < cnt ; i++ ) {\n', '      uint256 numBitCEO = _amounts[i];\n', '      address receiver = _receivers[i];\n', '      bCEOInstance.transferFrom(sender, receiver, numBitCEO * (10 ** uint256(18)));\n', '    }\n', '  }\n', '\n', '}']