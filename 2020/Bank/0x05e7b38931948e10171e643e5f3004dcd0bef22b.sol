['// File: openzeppelin-solidity-2.3.0/contracts/ownership/Ownable.sol\n', '\n', 'pragma solidity ^0.5.0;\n', '\n', '/**\n', ' * @dev Contract module which provides a basic access control mechanism, where\n', ' * there is an account (an owner) that can be granted exclusive access to\n', ' * specific functions.\n', ' *\n', ' * This module is used through inheritance. It will make available the modifier\n', ' * `onlyOwner`, which can be aplied to your functions to restrict their use to\n', ' * the owner.\n', ' */\n', 'contract Ownable {\n', '    address private _owner;\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    /**\n', '     * @dev Initializes the contract setting the deployer as the initial owner.\n', '     */\n', '    constructor () internal {\n', '        _owner = msg.sender;\n', '        emit OwnershipTransferred(address(0), _owner);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the address of the current owner.\n', '     */\n', '    function owner() public view returns (address) {\n', '        return _owner;\n', '    }\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(isOwner(), "Ownable: caller is not the owner");\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns true if the caller is the current owner.\n', '     */\n', '    function isOwner() public view returns (bool) {\n', '        return msg.sender == _owner;\n', '    }\n', '\n', '    /**\n', '     * @dev Leaves the contract without owner. It will not be possible to call\n', '     * `onlyOwner` functions anymore. Can only be called by the current owner.\n', '     *\n', '     * > Note: Renouncing ownership will leave the contract without an owner,\n', '     * thereby removing any functionality that is only available to the owner.\n', '     */\n', '    function renounceOwnership() public onlyOwner {\n', '        emit OwnershipTransferred(_owner, address(0));\n', '        _owner = address(0);\n', '    }\n', '\n', '    /**\n', '     * @dev Transfers ownership of the contract to a new account (`newOwner`).\n', '     * Can only be called by the current owner.\n', '     */\n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '        _transferOwnership(newOwner);\n', '    }\n', '\n', '    /**\n', '     * @dev Transfers ownership of the contract to a new account (`newOwner`).\n', '     */\n', '    function _transferOwnership(address newOwner) internal {\n', '        require(newOwner != address(0), "Ownable: new owner is the zero address");\n', '        emit OwnershipTransferred(_owner, newOwner);\n', '        _owner = newOwner;\n', '    }\n', '}\n', '\n', '// File: contracts/PriceOracle.sol\n', '\n', 'pragma solidity 0.5.16;\n', '\n', 'interface PriceOracle {\n', '    /// @dev Return the wad price of token0/token1, multiplied by 1e18\n', '    /// NOTE: (if you have 1 token0 how much you can sell it for token1)\n', '    function getPrice(address token0, address token1)\n', '        external view\n', '        returns (uint256 price, uint256 lastUpdate);\n', '}\n', '\n', '// File: contracts/SimplePriceOracle.sol\n', '\n', 'pragma solidity 0.5.16;\n', '\n', '\n', '\n', 'contract SimplePriceOracle is Ownable, PriceOracle {\n', '    event PriceUpdate(address indexed token0, address indexed token1, uint256 price);\n', '\n', '    struct PriceData {\n', '        uint192 price;\n', '        uint64 lastUpdate;\n', '    }\n', '\n', '    /// @notice Public price data mapping storage.\n', '    mapping (address => mapping (address => PriceData)) public store;\n', '\n', '    /// @dev Set the prices of the token token pairs. Must be called by the owner.\n', '    function setPrices(\n', '        address[] calldata token0s,\n', '        address[] calldata token1s,\n', '        uint256[] calldata prices\n', '    )\n', '        external\n', '        onlyOwner\n', '    {\n', '        uint256 len = token0s.length;\n', '        require(token1s.length == len, "bad token1s length");\n', '        require(prices.length == len, "bad prices length");\n', '        for (uint256 idx = 0; idx < len; idx++) {\n', '            address token0 = token0s[idx];\n', '            address token1 = token1s[idx];\n', '            uint256 price = prices[idx];\n', '            store[token0][token1] = PriceData({\n', '                price: uint192(price),\n', '                lastUpdate: uint64(now)\n', '            });\n', '            emit PriceUpdate(token0, token1, price);\n', '        }\n', '    }\n', '\n', '    /// @dev Return the wad price of token0/token1, multiplied by 1e18\n', '    /// NOTE: (if you have 1 token0 how much you can sell it for token1)\n', '    function getPrice(address token0, address token1)\n', '        external view\n', '        returns (uint256 price, uint256 lastUpdate)\n', '    {\n', '        PriceData memory data = store[token0][token1];\n', '        price = uint256(data.price);\n', '        lastUpdate = uint256(data.lastUpdate);\n', '        require(price != 0 && lastUpdate != 0, "bad price data");\n', '        return (price, lastUpdate);\n', '    }\n', '}']