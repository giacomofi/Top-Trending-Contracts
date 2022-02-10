['// SPDX-License-Identifier: MIT\n', 'pragma solidity 0.7.6;\n', '// pragma experimental SMTChecker;\n', '\n', 'import {TokenManager} from "./TokenManager.sol";\n', '\n', 'contract Distributor is TokenManager {\n', '    \n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', 'pragma solidity 0.7.6;\n', '// pragma experimental SMTChecker;\n', '\n', 'import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";\n', 'import {TransferHelper} from "@uniswap/lib/contracts/libraries/TransferHelper.sol";\n', '\n', 'contract TokenManager is Ownable {\n', '    /* receive function */\n', '\n', '    receive() external payable {}\n', '\n', '    /* admin functions */\n', '\n', '    function transferERC20(\n', '        address token,\n', '        address to,\n', '        uint256 value\n', '    ) external onlyOwner {\n', '        TransferHelper.safeTransfer(token, to, value);\n', '    }\n', '\n', '    function transferFromERC20(\n', '        address token,\n', '        address from,\n', '        address to,\n', '        uint256 value\n', '    ) external onlyOwner {\n', '        TransferHelper.safeTransferFrom(token, from, to, value);\n', '    }\n', '\n', '    function approveERC20(\n', '        address token,\n', '        address to,\n', '        uint256 value\n', '    ) external onlyOwner {\n', '        TransferHelper.safeApprove(token, to, value);\n', '    }\n', '\n', '    function transferETH(address to, uint256 value) external onlyOwner {\n', '        TransferHelper.safeTransferETH(to, value);\n', '    }\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity >=0.6.0 <0.8.0;\n', '\n', 'import "../utils/Context.sol";\n', '/**\n', ' * @dev Contract module which provides a basic access control mechanism, where\n', ' * there is an account (an owner) that can be granted exclusive access to\n', ' * specific functions.\n', ' *\n', ' * By default, the owner account will be the one that deploys the contract. This\n', ' * can later be changed with {transferOwnership}.\n', ' *\n', ' * This module is used through inheritance. It will make available the modifier\n', ' * `onlyOwner`, which can be applied to your functions to restrict their use to\n', ' * the owner.\n', ' */\n', 'abstract contract Ownable is Context {\n', '    address private _owner;\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    /**\n', '     * @dev Initializes the contract setting the deployer as the initial owner.\n', '     */\n', '    constructor () internal {\n', '        address msgSender = _msgSender();\n', '        _owner = msgSender;\n', '        emit OwnershipTransferred(address(0), msgSender);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the address of the current owner.\n', '     */\n', '    function owner() public view virtual returns (address) {\n', '        return _owner;\n', '    }\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(owner() == _msgSender(), "Ownable: caller is not the owner");\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Leaves the contract without owner. It will not be possible to call\n', '     * `onlyOwner` functions anymore. Can only be called by the current owner.\n', '     *\n', '     * NOTE: Renouncing ownership will leave the contract without an owner,\n', '     * thereby removing any functionality that is only available to the owner.\n', '     */\n', '    function renounceOwnership() public virtual onlyOwner {\n', '        emit OwnershipTransferred(_owner, address(0));\n', '        _owner = address(0);\n', '    }\n', '\n', '    /**\n', '     * @dev Transfers ownership of the contract to a new account (`newOwner`).\n', '     * Can only be called by the current owner.\n', '     */\n', '    function transferOwnership(address newOwner) public virtual onlyOwner {\n', '        require(newOwner != address(0), "Ownable: new owner is the zero address");\n', '        emit OwnershipTransferred(_owner, newOwner);\n', '        _owner = newOwner;\n', '    }\n', '}\n', '\n', '// SPDX-License-Identifier: GPL-3.0-or-later\n', '\n', 'pragma solidity >=0.6.0;\n', '\n', '// helper methods for interacting with ERC20 tokens and sending ETH that do not consistently return true/false\n', 'library TransferHelper {\n', '    function safeApprove(\n', '        address token,\n', '        address to,\n', '        uint256 value\n', '    ) internal {\n', "        // bytes4(keccak256(bytes('approve(address,uint256)')));\n", '        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x095ea7b3, to, value));\n', '        require(\n', '            success && (data.length == 0 || abi.decode(data, (bool))),\n', "            'TransferHelper::safeApprove: approve failed'\n", '        );\n', '    }\n', '\n', '    function safeTransfer(\n', '        address token,\n', '        address to,\n', '        uint256 value\n', '    ) internal {\n', "        // bytes4(keccak256(bytes('transfer(address,uint256)')));\n", '        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));\n', '        require(\n', '            success && (data.length == 0 || abi.decode(data, (bool))),\n', "            'TransferHelper::safeTransfer: transfer failed'\n", '        );\n', '    }\n', '\n', '    function safeTransferFrom(\n', '        address token,\n', '        address from,\n', '        address to,\n', '        uint256 value\n', '    ) internal {\n', "        // bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));\n", '        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x23b872dd, from, to, value));\n', '        require(\n', '            success && (data.length == 0 || abi.decode(data, (bool))),\n', "            'TransferHelper::transferFrom: transferFrom failed'\n", '        );\n', '    }\n', '\n', '    function safeTransferETH(address to, uint256 value) internal {\n', '        (bool success, ) = to.call{value: value}(new bytes(0));\n', "        require(success, 'TransferHelper::safeTransferETH: ETH transfer failed');\n", '    }\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity >=0.6.0 <0.8.0;\n', '\n', '/*\n', ' * @dev Provides information about the current execution context, including the\n', ' * sender of the transaction and its data. While these are generally available\n', ' * via msg.sender and msg.data, they should not be accessed in such a direct\n', ' * manner, since when dealing with GSN meta-transactions the account sending and\n', ' * paying for execution may not be the actual sender (as far as an application\n', ' * is concerned).\n', ' *\n', ' * This contract is only required for intermediate, library-like contracts.\n', ' */\n', 'abstract contract Context {\n', '    function _msgSender() internal view virtual returns (address payable) {\n', '        return msg.sender;\n', '    }\n', '\n', '    function _msgData() internal view virtual returns (bytes memory) {\n', '        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691\n', '        return msg.data;\n', '    }\n', '}\n', '\n', '{\n', '  "optimizer": {\n', '    "enabled": true,\n', '    "runs": 1000\n', '  },\n', '  "outputSelection": {\n', '    "*": {\n', '      "*": [\n', '        "evm.bytecode",\n', '        "evm.deployedBytecode",\n', '        "abi"\n', '      ]\n', '    }\n', '  },\n', '  "libraries": {}\n', '}']