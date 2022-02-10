['// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity 0.6.6;\n', '\n', '\n', 'interface AggregatorV3Interface {\n', '\n', '  function decimals() external view returns (uint8);\n', '  function description() external view returns (string memory);\n', '  function version() external view returns (uint256);\n', '\n', '  // getRoundData and latestRoundData should both raise "No data present"\n', '  // if they do not have data to report, instead of returning unset values\n', '  // which could be misinterpreted as actual reported values.\n', '  function getRoundData(uint80 _roundId)\n', '    external\n', '    view\n', '    returns (\n', '      uint80 roundId,\n', '      int256 answer,\n', '      uint256 startedAt,\n', '      uint256 updatedAt,\n', '      uint80 answeredInRound\n', '    );\n', '  function latestRoundData()\n', '    external\n', '    view\n', '    returns (\n', '      uint80 roundId,\n', '      int256 answer,\n', '      uint256 startedAt,\n', '      uint256 updatedAt,\n', '      uint80 answeredInRound\n', '    );\n', '\n', '}\n', '\n', '// \n', '/*\n', ' * @dev Provides information about the current execution context, including the\n', ' * sender of the transaction and its data. While these are generally available\n', ' * via msg.sender and msg.data, they should not be accessed in such a direct\n', ' * manner, since when dealing with GSN meta-transactions the account sending and\n', ' * paying for execution may not be the actual sender (as far as an application\n', ' * is concerned).\n', ' *\n', ' * This contract is only required for intermediate, library-like contracts.\n', ' */\n', 'abstract contract Context {\n', '    function _msgSender() internal view virtual returns (address payable) {\n', '        return msg.sender;\n', '    }\n', '\n', '    function _msgData() internal view virtual returns (bytes memory) {\n', '        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691\n', '        return msg.data;\n', '    }\n', '}\n', '\n', '// \n', '/**\n', ' * @dev Contract module which provides a basic access control mechanism, where\n', ' * there is an account (an owner) that can be granted exclusive access to\n', ' * specific functions.\n', ' *\n', ' * By default, the owner account will be the one that deploys the contract. This\n', ' * can later be changed with {transferOwnership}.\n', ' *\n', ' * This module is used through inheritance. It will make available the modifier\n', ' * `onlyOwner`, which can be applied to your functions to restrict their use to\n', ' * the owner.\n', ' */\n', 'contract Ownable is Context {\n', '    address private _owner;\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    /**\n', '     * @dev Initializes the contract setting the deployer as the initial owner.\n', '     */\n', '    constructor () internal {\n', '        address msgSender = _msgSender();\n', '        _owner = msgSender;\n', '        emit OwnershipTransferred(address(0), msgSender);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the address of the current owner.\n', '     */\n', '    function owner() public view returns (address) {\n', '        return _owner;\n', '    }\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(_owner == _msgSender(), "Ownable: caller is not the owner");\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Leaves the contract without owner. It will not be possible to call\n', '     * `onlyOwner` functions anymore. Can only be called by the current owner.\n', '     *\n', '     * NOTE: Renouncing ownership will leave the contract without an owner,\n', '     * thereby removing any functionality that is only available to the owner.\n', '     */\n', '    function renounceOwnership() public virtual onlyOwner {\n', '        emit OwnershipTransferred(_owner, address(0));\n', '        _owner = address(0);\n', '    }\n', '\n', '    /**\n', '     * @dev Transfers ownership of the contract to a new account (`newOwner`).\n', '     * Can only be called by the current owner.\n', '     */\n', '    function transferOwnership(address newOwner) public virtual onlyOwner {\n', '        require(newOwner != address(0), "Ownable: new owner is the zero address");\n', '        emit OwnershipTransferred(_owner, newOwner);\n', '        _owner = newOwner;\n', '    }\n', '}\n', '\n', 'abstract contract PriceProvider is Ownable {\n', '\n', '    address public manager;\n', '\n', '    string public providerName;\n', '\n', '    uint8 public constant decimals = 2; // decimals of ethereum price\n', '    bool public updateRequred;\n', '\n', '    /**\n', '     * @dev Constructor.\n', '     * @param _providerName Name of provider.\n', '     * @param _manager Address of price manager.\n', '     */\n', '\n', '    constructor(string memory _providerName, address _manager, bool _updateRequred) public Ownable() {\n', '        providerName = _providerName;\n', '        manager = _manager;\n', '        updateRequred = _updateRequred;\n', '    }\n', '\n', '    /**\n', '     * @dev Set Price manager.\n', '     * @param _manager Address of price manager.\n', '     */\n', '\n', '    function setManager(address _manager) external onlyOwner {\n', '        manager = _manager;\n', '    }\n', '\n', '    /**\n', '     * @return Last ethereum price.\n', '     */\n', '\n', '    function lastPrice() public virtual view returns (uint32);\n', '}\n', '\n', 'contract PriceProviderChainLink is PriceProvider {\n', '\n', '    AggregatorV3Interface public priceFeed;\n', '\n', '    /**\n', '     * @dev Constructor.\n', '     * @param _manager Address of price manager.\n', '     */\n', '\n', '    constructor(address _priceFeed, address _manager) public PriceProvider("ChainLink", _manager, false) {\n', '        priceFeed = AggregatorV3Interface(_priceFeed);\n', '    }\n', '\n', '    /**\n', '     * @return Last ethereum price.\n', '     */\n', '\n', '    function lastPrice() public override view returns (uint32) {\n', '        (,int price,,uint timeStamp,) = priceFeed.latestRoundData();\n', '        require(timeStamp > 0, "Round not complete");\n', '        return uint32(price / 1000000);\n', '    }\n', '}']