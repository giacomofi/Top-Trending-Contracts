['pragma solidity ^0.4.24;\n', '\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipRenounced(address indexed previousOwner);\n', '  event OwnershipTransferred(\n', '    address indexed previousOwner,\n', '    address indexed newOwner\n', '  );\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  constructor() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to relinquish control of the contract.\n', '   * @notice Renouncing to ownership will leave the contract without an owner.\n', '   * It will not be possible to call the functions with the `onlyOwner`\n', '   * modifier anymore.\n', '   */\n', '  function renounceOwnership() public onlyOwner {\n', '    emit OwnershipRenounced(owner);\n', '    owner = address(0);\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param _newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address _newOwner) public onlyOwner {\n', '    _transferOwnership(_newOwner);\n', '  }\n', '\n', '  /**\n', '   * @dev Transfers control of the contract to a newOwner.\n', '   * @param _newOwner The address to transfer ownership to.\n', '   */\n', '  function _transferOwnership(address _newOwner) internal {\n', '    require(_newOwner != address(0));\n', '    emit OwnershipTransferred(owner, _newOwner);\n', '    owner = _newOwner;\n', '  }\n', '}\n', '\n', '\n', 'interface SaleInterface {\n', '    function saleTokensPerUnit() external view returns(uint256);\n', '    function extraTokensPerUnit() external view returns(uint256);\n', '    function unitContributions(address) external view returns(uint256);\n', '    function disbursementHandler() external view returns(address);\n', '}\n', '\n', '\n', '\n', '\n', '\n', 'contract Saft is SaleInterface, Ownable {\n', '\n', '  uint256 public c_saleTokensPerUnit;\n', '  uint256 public c_extraTokensPerUnit;\n', '  mapping(address => uint256) public c_unitContributions;\n', '  address public c_disbursementHandler;\n', '\n', '  constructor (uint256 _saleTokensPerUnit, uint256 _extraTokensPerUnit, address _disbursementHandler) Ownable() public {\n', '    c_saleTokensPerUnit = _saleTokensPerUnit;\n', '    c_extraTokensPerUnit = _extraTokensPerUnit;\n', '    c_disbursementHandler = _disbursementHandler;\n', '  }\n', '\n', '  function saleTokensPerUnit() external view returns (uint256) { return c_saleTokensPerUnit; }\n', '  function extraTokensPerUnit() external view returns (uint256) { return c_extraTokensPerUnit; }\n', '  function unitContributions(address contributor) external view returns (uint256) { return c_unitContributions[contributor]; }\n', '  function disbursementHandler() external view returns (address) { return c_disbursementHandler; }\n', '\n', '  function setSaleTokensPerUnit(uint256 _saleTokensPerUnit) public onlyOwner {\n', '    c_saleTokensPerUnit = _saleTokensPerUnit;\n', '  }\n', '\n', '  function setExtraTokensPerUnit(uint256 _extraTokensPerUnit) public onlyOwner {\n', '    c_extraTokensPerUnit = _extraTokensPerUnit;\n', '  }\n', '\n', '  function setUnitContributions(address contributor, uint256 units) public onlyOwner {\n', '    c_unitContributions[contributor] = units;\n', '  }\n', '\n', '  function setDisbursementHandler(address _disbursementHandler) public onlyOwner {\n', '    c_disbursementHandler = _disbursementHandler;\n', '  }\n', '}']