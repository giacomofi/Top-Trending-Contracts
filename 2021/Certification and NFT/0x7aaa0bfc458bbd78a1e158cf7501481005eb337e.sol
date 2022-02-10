['/**\n', ' *Submitted for verification at Etherscan.io on 2021-04-09\n', '*/\n', '\n', '// Sources flattened with hardhat v2.0.2 https://hardhat.org\n', '\n', '// File contracts/libraries/SafeMath.sol\n', '\n', '// SPDX-License-Identifier: MIT\n', 'pragma solidity 0.7.4;\n', '\n', '// A library for performing overflow-safe math, courtesy of DappHub: https://github.com/dapphub/ds-math/blob/d0ef6d6a5f/src/math.sol\n', '// Modified to include only the essentials\n', 'library SafeMath {\n', '    function add(uint256 x, uint256 y) internal pure returns (uint256 z) {\n', '        require((z = x + y) >= x, "MATH:: ADD_OVERFLOW");\n', '    }\n', '\n', '    function sub(uint256 x, uint256 y) internal pure returns (uint256 z) {\n', '        require((z = x - y) <= x, "MATH:: SUB_UNDERFLOW");\n', '    }\n', '\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b, "MATH:: MUL_OVERFLOW");\n', '\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b > 0, "MATH:: DIVISION_BY_ZERO");\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '        return c;\n', '    }\n', '\n', '    function min(uint256 x, uint256 y) internal pure returns (uint256 z) {\n', '        z = x < y ? x : y;\n', '    }\n', '\n', '    // babylonian method (https://en.wikipedia.org/wiki/Methods_of_computing_square_roots#Babylonian_method)\n', '    function sqrt(uint256 y) internal pure returns (uint256 z) {\n', '        if (y > 3) {\n', '            z = y;\n', '            uint256 x = y / 2 + 1;\n', '            while (x < z) {\n', '                z = x;\n', '                x = (y / x + x) / 2;\n', '            }\n', '        } else if (y != 0) {\n', '            z = 1;\n', '        }\n', '    }\n', '}\n', '\n', '\n', '// File contracts/interfaces/IERC20.sol\n', '\n', 'pragma solidity 0.7.4;\n', '\n', 'interface IERC20 {\n', '    function totalSupply() external view returns (uint256);\n', '\n', '    function balanceOf(address account) external view returns (uint256);\n', '\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '\n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '\n', '    function transfer(address recipient, uint256 amount) external returns (bool);\n', '\n', '    function transferFrom(\n', '        address sender,\n', '        address recipient,\n', '        uint256 amount\n', '    ) external returns (bool);\n', '\n', '    function burn(uint256 value) external returns (bool);\n', '\n', '    function permit(\n', '        address owner,\n', '        address spender,\n', '        uint256 value,\n', '        uint256 deadline,\n', '        uint8 v,\n', '        bytes32 r,\n', '        bytes32 s\n', '    ) external;\n', '}\n', '\n', '\n', '// File contracts/libraries/Address.sol\n', '\n', '\n', 'pragma solidity 0.7.4;\n', '\n', '/**\n', ' * @dev Collection of functions related to the address type\n', ' */\n', 'library Address {\n', '    /**\n', '     * @dev Returns true if `account` is a contract.\n', '     *\n', '     * [IMPORTANT]\n', '     * ====\n', '     * It is unsafe to assume that an address for which this function returns\n', '     * false is an externally-owned account (EOA) and not a contract.\n', '     *\n', '     * Among others, `isContract` will return false for the following\n', '     * types of addresses:\n', '     *\n', '     *  - an externally-owned account\n', '     *  - a contract in construction\n', '     *  - an address where a contract will be created\n', '     *  - an address where a contract lived, but was destroyed\n', '     * ====\n', '     */\n', '    function isContract(address account) internal view returns (bool) {\n', '        // This method relies on extcodesize, which returns 0 for contracts in\n', '        // construction, since the code is only stored at the end of the\n', '        // constructor execution.\n', '\n', '        uint256 size;\n', '        // solhint-disable-next-line no-inline-assembly\n', '        assembly {\n', '            size := extcodesize(account)\n', '        }\n', '        return size > 0;\n', '    }\n', '\n', '    /**\n', "     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to\n", '     * `recipient`, forwarding all available gas and reverting on errors.\n', '     *\n', '     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost\n', '     * of certain opcodes, possibly making contracts go over the 2300 gas limit\n', '     * imposed by `transfer`, making them unable to receive funds via\n', '     * `transfer`. {sendValue} removes this limitation.\n', '     *\n', '     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].\n', '     *\n', '     * IMPORTANT: because control is transferred to `recipient`, care must be\n', '     * taken to not create reentrancy vulnerabilities. Consider using\n', '     * {ReentrancyGuard} or the\n', '     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].\n', '     */\n', '    function sendValue(address payable recipient, uint256 amount) internal {\n', '        require(address(this).balance >= amount, "Address: insufficient balance");\n', '\n', '        // solhint-disable-next-line avoid-low-level-calls, avoid-call-value\n', '        (bool success, ) = recipient.call{ value: amount }("");\n', '        require(success, "Address: unable to send value, recipient may have reverted");\n', '    }\n', '\n', '    /**\n', '     * @dev Performs a Solidity function call using a low level `call`. A\n', '     * plain`call` is an unsafe replacement for a function call: use this\n', '     * function instead.\n', '     *\n', '     * If `target` reverts with a revert reason, it is bubbled up by this\n', '     * function (like regular Solidity function calls).\n', '     *\n', '     * Returns the raw returned data. To convert to the expected return value,\n', '     * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - `target` must be a contract.\n', '     * - calling `target` with `data` must not revert.\n', '     *\n', '     * _Available since v3.1._\n', '     */\n', '    function functionCall(address target, bytes memory data) internal returns (bytes memory) {\n', '        return functionCall(target, data, "Address: low-level call failed");\n', '    }\n', '\n', '    /**\n', '     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with\n', '     * `errorMessage` as a fallback revert reason when `target` reverts.\n', '     *\n', '     * _Available since v3.1._\n', '     */\n', '    function functionCall(\n', '        address target,\n', '        bytes memory data,\n', '        string memory errorMessage\n', '    ) internal returns (bytes memory) {\n', '        return functionCallWithValue(target, data, 0, errorMessage);\n', '    }\n', '\n', '    /**\n', '     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],\n', '     * but also transferring `value` wei to `target`.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - the calling contract must have an ETH balance of at least `value`.\n', '     * - the called Solidity function must be `payable`.\n', '     *\n', '     * _Available since v3.1._\n', '     */\n', '    function functionCallWithValue(\n', '        address target,\n', '        bytes memory data,\n', '        uint256 value\n', '    ) internal returns (bytes memory) {\n', '        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");\n', '    }\n', '\n', '    /**\n', '     * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but\n', '     * with `errorMessage` as a fallback revert reason when `target` reverts.\n', '     *\n', '     * _Available since v3.1._\n', '     */\n', '    function functionCallWithValue(\n', '        address target,\n', '        bytes memory data,\n', '        uint256 value,\n', '        string memory errorMessage\n', '    ) internal returns (bytes memory) {\n', '        require(address(this).balance >= value, "Address: insufficient balance for call");\n', '        require(isContract(target), "Address: call to non-contract");\n', '\n', '        // solhint-disable-next-line avoid-low-level-calls\n', '        (bool success, bytes memory returndata) = target.call{ value: value }(data);\n', '        return _verifyCallResult(success, returndata, errorMessage);\n', '    }\n', '\n', '    /**\n', '     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],\n', '     * but performing a static call.\n', '     *\n', '     * _Available since v3.3._\n', '     */\n', '    function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {\n', '        return functionStaticCall(target, data, "Address: low-level static call failed");\n', '    }\n', '\n', '    /**\n', '     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],\n', '     * but performing a static call.\n', '     *\n', '     * _Available since v3.3._\n', '     */\n', '    function functionStaticCall(\n', '        address target,\n', '        bytes memory data,\n', '        string memory errorMessage\n', '    ) internal view returns (bytes memory) {\n', '        require(isContract(target), "Address: static call to non-contract");\n', '\n', '        // solhint-disable-next-line avoid-low-level-calls\n', '        (bool success, bytes memory returndata) = target.staticcall(data);\n', '        return _verifyCallResult(success, returndata, errorMessage);\n', '    }\n', '\n', '    /**\n', '     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],\n', '     * but performing a delegate call.\n', '     *\n', '     * _Available since v3.4._\n', '     */\n', '    function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {\n', '        return functionDelegateCall(target, data, "Address: low-level delegate call failed");\n', '    }\n', '\n', '    /**\n', '     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],\n', '     * but performing a delegate call.\n', '     *\n', '     * _Available since v3.4._\n', '     */\n', '    function functionDelegateCall(\n', '        address target,\n', '        bytes memory data,\n', '        string memory errorMessage\n', '    ) internal returns (bytes memory) {\n', '        require(isContract(target), "Address: delegate call to non-contract");\n', '\n', '        // solhint-disable-next-line avoid-low-level-calls\n', '        (bool success, bytes memory returndata) = target.delegatecall(data);\n', '        return _verifyCallResult(success, returndata, errorMessage);\n', '    }\n', '\n', '    function _verifyCallResult(\n', '        bool success,\n', '        bytes memory returndata,\n', '        string memory errorMessage\n', '    ) private pure returns (bytes memory) {\n', '        if (success) {\n', '            return returndata;\n', '        } else {\n', '            // Look for revert reason and bubble it up if present\n', '            if (returndata.length > 0) {\n', '                // The easiest way to bubble the revert reason is using memory via assembly\n', '\n', '                // solhint-disable-next-line no-inline-assembly\n', '                assembly {\n', '                    let returndata_size := mload(returndata)\n', '                    revert(add(32, returndata), returndata_size)\n', '                }\n', '            } else {\n', '                revert(errorMessage);\n', '            }\n', '        }\n', '    }\n', '}\n', '\n', '\n', '// File contracts/libraries/SafeERC20.sol\n', '\n', '\n', 'pragma solidity 0.7.4;\n', '\n', '\n', '\n', '/**\n', ' * @title SafeERC20\n', ' * @dev Wrappers around ERC20 operations that throw on failure (when the token\n', ' * contract returns false). Tokens that return no value (and instead revert or\n', ' * throw on failure) are also supported, non-reverting calls are assumed to be\n', ' * successful.\n', ' * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,\n', ' * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.\n', ' */\n', 'library SafeERC20 {\n', '    using SafeMath for uint256;\n', '    using Address for address;\n', '\n', '    function safeTransfer(\n', '        IERC20 token,\n', '        address to,\n', '        uint256 value\n', '    ) internal {\n', '        _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));\n', '    }\n', '\n', '    function safeTransferFrom(\n', '        IERC20 token,\n', '        address from,\n', '        address to,\n', '        uint256 value\n', '    ) internal {\n', '        _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));\n', '    }\n', '\n', '    /**\n', '     * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement\n', '     * on the return value: the return value is optional (but if data is returned, it must not be false).\n', '     * @param token The token targeted by the call.\n', '     * @param data The call data (encoded using abi.encode or one of its variants).\n', '     */\n', '    function _callOptionalReturn(IERC20 token, bytes memory data) private {\n', "        // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since\n", "        // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that\n", '        // the target address contains contract code and also asserts for success in the low-level call.\n', '\n', '        bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");\n', '        if (returndata.length > 0) {\n', '            // Return data is optional\n', '            // solhint-disable-next-line max-line-length\n', '            require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");\n', '        }\n', '    }\n', '}\n', '\n', '\n', '// File contracts/interfaces/IFlashProtocol.sol\n', '\n', '\n', 'pragma solidity 0.7.4;\n', '\n', 'interface IFlashProtocol {\n', '    function stake(\n', '        uint256 _amountIn,\n', '        uint256 _days,\n', '        address _receiver,\n', '        bytes calldata _data\n', '    )\n', '        external\n', '        returns (\n', '            uint256 mintedAmount,\n', '            uint256 matchedAmount,\n', '            bytes32 id\n', '        );\n', '\n', '    function unstake(bytes32 _id) external returns (uint256 withdrawAmount);\n', '\n', '    function getFPY(uint256 _amountIn) external view returns (uint256);\n', '}\n', '\n', '\n', '// File contracts/pool/interfaces/IPool.sol\n', '\n', '\n', 'pragma solidity 0.7.4;\n', '\n', 'interface IPool {\n', '    function initialize(address _token) external;\n', '\n', '    function stakeWithFeeRewardDistribution(\n', '        uint256 _amountIn,\n', '        address _staker,\n', '        uint256 _expectedOutput\n', '    ) external returns (uint256 result);\n', '\n', '    function addLiquidity(\n', '        uint256 _amountFLASH,\n', '        uint256 _amountALT,\n', '        uint256 _amountFLASHMin,\n', '        uint256 _amountALTMin,\n', '        address _maker\n', '    )\n', '        external\n', '        returns (\n', '            uint256,\n', '            uint256,\n', '            uint256\n', '        );\n', '\n', '    function removeLiquidity(address _maker) external returns (uint256, uint256);\n', '\n', '    function swapWithFeeRewardDistribution(\n', '        uint256 _amountIn,\n', '        address _staker,\n', '        uint256 _expectedOutput\n', '    ) external returns (uint256 result);\n', '}\n', '\n', '\n', '// File contracts/pool/contracts/PoolERC20.sol\n', '\n', '\n', 'pragma solidity 0.7.4;\n', '\n', '\n', '// Lightweight token modelled after UNI-LP:\n', '// https://github.com/Uniswap/uniswap-v2-core/blob/v1.0.1/contracts/UniswapV2ERC20.sol\n', '// Adds:\n', '//   - An exposed `mint()` with minting role\n', '//   - An exposed `burn()`\n', '//   - ERC-3009 (`transferWithAuthorization()`)\n', '//   - flashMint() - allows to flashMint an arbitrary amount of FLASH, with the\n', '//     condition that it is burned before the end of the transaction.\n', 'contract PoolERC20 is IERC20 {\n', '    using SafeMath for uint256;\n', '\n', '    // bytes32 private constant EIP712DOMAIN_HASH =\n', '    // keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)")\n', '    bytes32 private constant EIP712DOMAIN_HASH = 0x8b73c3c69bb8fe3d512ecc4cf759cc79239f7b179b0ffacaa9a75d522b39400f;\n', '\n', '    // bytes32 private constant NAME_HASH = keccak256("FLASH-ALT-LP Token")\n', '    bytes32 private constant NAME_HASH = 0xfdde3a7807889787f51ab17062704a0d81341ba7debe5a9773b58a1b5e5f422c;\n', '\n', '    // bytes32 private constant VERSION_HASH = keccak256("2")\n', '    bytes32 private constant VERSION_HASH = 0xad7c5bef027816a800da1736444fb58a807ef4c9603b7848673f7e3a68eb14a5;\n', '\n', '    // bytes32 public constant PERMIT_TYPEHASH =\n', '    // keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");\n', '    bytes32 public constant PERMIT_TYPEHASH = 0x6e71edae12b1b97f4d1f60370fef10105fa2faae0126114a169c64845d6126c9;\n', '\n', '    // bytes32 public constant TRANSFER_WITH_AUTHORIZATION_TYPEHASH =\n', '    // keccak256("TransferWithAuthorization(address from,address to,uint256 value,uint256 validAfter,uint256 validBefore,bytes32 nonce)");\n', '    bytes32\n', '        public constant TRANSFER_WITH_AUTHORIZATION_TYPEHASH = 0x7c7c6cdb67a18743f49ec6fa9b35f50d52ed05cbed4cc592e13b44501c1a2267;\n', '\n', '    string public constant name = "FLASH-ALT-LP Token";\n', '    string public constant symbol = "FLASH-ALT-LP";\n', '    uint8 public constant decimals = 18;\n', '\n', '    uint256 public override totalSupply;\n', '\n', '    address public minter;\n', '\n', '    mapping(address => uint256) public override balanceOf;\n', '    mapping(address => mapping(address => uint256)) public override allowance;\n', '\n', '    // ERC-2612, ERC-3009 state\n', '    mapping(address => uint256) public nonces;\n', '    mapping(address => mapping(bytes32 => bool)) public authorizationState;\n', '\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event AuthorizationUsed(address indexed authorizer, bytes32 indexed nonce);\n', '\n', '    function _validateSignedData(\n', '        address signer,\n', '        bytes32 encodeData,\n', '        uint8 v,\n', '        bytes32 r,\n', '        bytes32 s\n', '    ) internal view {\n', '        bytes32 digest = keccak256(abi.encodePacked("\\x19\\x01", getDomainSeparator(), encodeData));\n', '        address recoveredAddress = ecrecover(digest, v, r, s);\n', '        // Explicitly disallow authorizations for address(0) as ecrecover returns address(0) on malformed messages\n', '        require(recoveredAddress != address(0) && recoveredAddress == signer, "FLASH-ALT-LP Token:: INVALID_SIGNATURE");\n', '    }\n', '\n', '    function _mint(address to, uint256 value) internal {\n', '        totalSupply = totalSupply.add(value);\n', '        balanceOf[to] = balanceOf[to].add(value);\n', '        emit Transfer(address(0), to, value);\n', '    }\n', '\n', '    function _burn(address from, uint256 value) internal {\n', "        // Balance is implicitly checked with SafeMath's underflow protection\n", '        balanceOf[from] = balanceOf[from].sub(value);\n', '        totalSupply = totalSupply.sub(value);\n', '        emit Transfer(from, address(0), value);\n', '    }\n', '\n', '    function _approve(\n', '        address owner,\n', '        address spender,\n', '        uint256 value\n', '    ) private {\n', '        allowance[owner][spender] = value;\n', '        emit Approval(owner, spender, value);\n', '    }\n', '\n', '    function _transfer(\n', '        address from,\n', '        address to,\n', '        uint256 value\n', '    ) private {\n', '        require(to != address(0), "FLASH-ALT-LP Token:: RECEIVER_IS_TOKEN_OR_ZERO");\n', "        // Balance is implicitly checked with SafeMath's underflow protection\n", '        balanceOf[from] = balanceOf[from].sub(value);\n', '        balanceOf[to] = balanceOf[to].add(value);\n', '        emit Transfer(from, to, value);\n', '    }\n', '\n', '    function getChainId() public pure returns (uint256 chainId) {\n', '        // solhint-disable-next-line no-inline-assembly\n', '        assembly {\n', '            chainId := chainid()\n', '        }\n', '    }\n', '\n', '    function getDomainSeparator() public view returns (bytes32) {\n', '        return keccak256(abi.encode(EIP712DOMAIN_HASH, NAME_HASH, VERSION_HASH, getChainId(), address(this)));\n', '    }\n', '\n', '    function burn(uint256 value) external override returns (bool) {\n', '        _burn(msg.sender, value);\n', '        return true;\n', '    }\n', '\n', '    function approve(address spender, uint256 value) external override returns (bool) {\n', '        _approve(msg.sender, spender, value);\n', '        return true;\n', '    }\n', '\n', '    function transfer(address to, uint256 value) external override returns (bool) {\n', '        _transfer(msg.sender, to, value);\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(\n', '        address from,\n', '        address to,\n', '        uint256 value\n', '    ) external override returns (bool) {\n', '        uint256 fromAllowance = allowance[from][msg.sender];\n', '        if (fromAllowance != uint256(-1)) {\n', "            // Allowance is implicitly checked with SafeMath's underflow protection\n", '            allowance[from][msg.sender] = fromAllowance.sub(value);\n', '        }\n', '        _transfer(from, to, value);\n', '        return true;\n', '    }\n', '\n', '    function permit(\n', '        address owner,\n', '        address spender,\n', '        uint256 value,\n', '        uint256 deadline,\n', '        uint8 v,\n', '        bytes32 r,\n', '        bytes32 s\n', '    ) external override {\n', '        require(deadline >= block.timestamp, "FLASH-ALT-LP Token:: AUTH_EXPIRED");\n', '\n', '        bytes32 encodeData = keccak256(abi.encode(PERMIT_TYPEHASH, owner, spender, value, nonces[owner], deadline));\n', '        nonces[owner] = nonces[owner].add(1);\n', '        _validateSignedData(owner, encodeData, v, r, s);\n', '\n', '        _approve(owner, spender, value);\n', '    }\n', '\n', '    function transferWithAuthorization(\n', '        address from,\n', '        address to,\n', '        uint256 value,\n', '        uint256 validAfter,\n', '        uint256 validBefore,\n', '        bytes32 nonce,\n', '        uint8 v,\n', '        bytes32 r,\n', '        bytes32 s\n', '    ) external {\n', '        require(block.timestamp > validAfter, "FLASH-ALT-LP Token:: AUTH_NOT_YET_VALID");\n', '        require(block.timestamp < validBefore, "FLASH-ALT-LP Token:: AUTH_EXPIRED");\n', '        require(!authorizationState[from][nonce], "FLASH-ALT-LP Token:: AUTH_ALREADY_USED");\n', '\n', '        bytes32 encodeData = keccak256(\n', '            abi.encode(TRANSFER_WITH_AUTHORIZATION_TYPEHASH, from, to, value, validAfter, validBefore, nonce)\n', '        );\n', '        _validateSignedData(from, encodeData, v, r, s);\n', '\n', '        authorizationState[from][nonce] = true;\n', '        emit AuthorizationUsed(from, nonce);\n', '\n', '        _transfer(from, to, value);\n', '    }\n', '}\n', '\n', '\n', '// File contracts/pool/contracts/Pool.sol\n', '\n', '\n', 'pragma solidity 0.7.4;\n', '\n', '\n', '\n', '\n', 'contract Pool is PoolERC20, IPool {\n', '    using SafeMath for uint256;\n', '    using SafeERC20 for IERC20;\n', '\n', '    uint256 public constant MINIMUM_LIQUIDITY = 10**3;\n', '\n', '    address public constant FLASH_TOKEN = 0x20398aD62bb2D930646d45a6D4292baa0b860C1f;\n', '    address public constant FLASH_PROTOCOL = 0x15EB0c763581329C921C8398556EcFf85Cc48275;\n', '\n', '    uint256 public reserveFlashAmount;\n', '    uint256 public reserveAltAmount;\n', '    uint256 private unlocked = 1;\n', '\n', '    address public token;\n', '    address public factory;\n', '\n', '    modifier lock() {\n', '        require(unlocked == 1, "Pool: LOCKED");\n', '        unlocked = 0;\n', '        _;\n', '        unlocked = 1;\n', '    }\n', '\n', '    modifier onlyFactory() {\n', '        require(msg.sender == factory, "Pool:: ONLY_FACTORY");\n', '        _;\n', '    }\n', '\n', '    constructor() {\n', '        factory = msg.sender;\n', '    }\n', '\n', '    function initialize(address _token) public override onlyFactory {\n', '        token = _token;\n', '    }\n', '\n', '    function swapWithFeeRewardDistribution(\n', '        uint256 _amountIn,\n', '        address _staker,\n', '        uint256 _expectedOutput\n', '    ) public override lock onlyFactory returns (uint256 result) {\n', '        result = getAPYSwap(_amountIn);\n', '        require(_expectedOutput <= result, "Pool:: EXPECTED_IS_GREATER");\n', '        calcNewReserveSwap(_amountIn, result);\n', '        IERC20(FLASH_TOKEN).safeTransfer(_staker, result);\n', '    }\n', '\n', '    function stakeWithFeeRewardDistribution(\n', '        uint256 _amountIn,\n', '        address _staker,\n', '        uint256 _expectedOutput\n', '    ) public override lock onlyFactory returns (uint256 result) {\n', '        result = getAPYStake(_amountIn);\n', '        require(_expectedOutput <= result, "Pool:: EXPECTED_IS_GREATER");\n', '        calcNewReserveStake(_amountIn, result);\n', '        IERC20(token).safeTransfer(_staker, result);\n', '    }\n', '\n', '    function addLiquidity(\n', '        uint256 _amountFLASH,\n', '        uint256 _amountALT,\n', '        uint256 _amountFLASHMin,\n', '        uint256 _amountALTMin,\n', '        address _maker\n', '    )\n', '        public\n', '        override\n', '        onlyFactory\n', '        returns (\n', '            uint256 amountFLASH,\n', '            uint256 amountALT,\n', '            uint256 liquidity\n', '        )\n', '    {\n', '        (amountFLASH, amountALT) = _addLiquidity(_amountFLASH, _amountALT, _amountFLASHMin, _amountALTMin);\n', '        liquidity = mintLiquidityTokens(_maker, amountFLASH, amountALT);\n', '        calcNewReserveAddLiquidity(amountFLASH, amountALT);\n', '    }\n', '\n', '    function removeLiquidity(address _maker)\n', '        public\n', '        override\n', '        onlyFactory\n', '        returns (uint256 amountFLASH, uint256 amountALT)\n', '    {\n', '        (amountFLASH, amountALT) = burn(_maker);\n', '    }\n', '\n', '    function getAPYStake(uint256 _amountIn) public view returns (uint256 result) {\n', '        uint256 amountInWithFee = _amountIn.mul(getLPFee());\n', '        uint256 num = amountInWithFee.mul(reserveAltAmount);\n', '        uint256 den = (reserveFlashAmount.mul(1000)).add(amountInWithFee);\n', '        result = num.div(den);\n', '    }\n', '\n', '    function getAPYSwap(uint256 _amountIn) public view returns (uint256 result) {\n', '        uint256 amountInWithFee = _amountIn.mul(getLPFee());\n', '        uint256 num = amountInWithFee.mul(reserveFlashAmount);\n', '        uint256 den = (reserveAltAmount.mul(1000)).add(amountInWithFee);\n', '        result = num.div(den);\n', '    }\n', '\n', '    function getLPFee() public view returns (uint256) {\n', '        uint256 fpy = IFlashProtocol(FLASH_PROTOCOL).getFPY(0);\n', '        return uint256(1000).sub(fpy.div(5e15));\n', '    }\n', '\n', '    function quote(\n', '        uint256 _amountA,\n', '        uint256 _reserveA,\n', '        uint256 _reserveB\n', '    ) public pure returns (uint256 amountB) {\n', '        require(_amountA > 0, "Pool:: INSUFFICIENT_AMOUNT");\n', '        require(_reserveA > 0 && _reserveB > 0, "Pool:: INSUFFICIENT_LIQUIDITY");\n', '        amountB = _amountA.mul(_reserveB).div(_reserveA);\n', '    }\n', '\n', '    function burn(address to) private lock returns (uint256 amountFLASH, uint256 amountALT) {\n', '        uint256 balanceFLASH = IERC20(FLASH_TOKEN).balanceOf(address(this));\n', '        uint256 balanceALT = IERC20(token).balanceOf(address(this));\n', '        uint256 liquidity = balanceOf[address(this)];\n', '\n', '        amountFLASH = liquidity.mul(balanceFLASH) / totalSupply;\n', '        amountALT = liquidity.mul(balanceALT) / totalSupply;\n', '\n', '        require(amountFLASH > 0 && amountALT > 0, "Pool:: INSUFFICIENT_LIQUIDITY_BURNED");\n', '\n', '        _burn(address(this), liquidity);\n', '\n', '        IERC20(FLASH_TOKEN).safeTransfer(to, amountFLASH);\n', '        IERC20(token).safeTransfer(to, amountALT);\n', '\n', '        balanceFLASH = balanceFLASH.sub(IERC20(FLASH_TOKEN).balanceOf(address(this)));\n', '        balanceALT = balanceALT.sub(IERC20(token).balanceOf(address(this)));\n', '\n', '        calcNewReserveRemoveLiquidity(balanceFLASH, balanceALT);\n', '    }\n', '\n', '    function _addLiquidity(\n', '        uint256 _amountFLASH,\n', '        uint256 _amountALT,\n', '        uint256 _amountFLASHMin,\n', '        uint256 _amountALTMin\n', '    ) private view returns (uint256 amountFLASH, uint256 amountALT) {\n', '        if (reserveAltAmount == 0 && reserveFlashAmount == 0) {\n', '            (amountFLASH, amountALT) = (_amountFLASH, _amountALT);\n', '        } else {\n', '            uint256 amountALTQuote = quote(_amountFLASH, reserveFlashAmount, reserveAltAmount);\n', '            if (amountALTQuote <= _amountALT) {\n', '                require(amountALTQuote >= _amountALTMin, "Pool:: INSUFFICIENT_B_AMOUNT");\n', '                (amountFLASH, amountALT) = (_amountFLASH, amountALTQuote);\n', '            } else {\n', '                uint256 amountFLASHQuote = quote(_amountALT, reserveAltAmount, reserveFlashAmount);\n', '                require(\n', '                    (amountFLASHQuote <= _amountFLASH) && (amountFLASHQuote >= _amountFLASHMin),\n', '                    "Pool:: INSUFFICIENT_A_AMOUNT"\n', '                );\n', '                (amountFLASH, amountALT) = (amountFLASHQuote, _amountALT);\n', '            }\n', '        }\n', '    }\n', '\n', '    function mintLiquidityTokens(\n', '        address _to,\n', '        uint256 _flashAmount,\n', '        uint256 _altAmount\n', '    ) private returns (uint256 liquidity) {\n', '        if (totalSupply == 0) {\n', '            liquidity = SafeMath.sqrt(_flashAmount.mul(_altAmount)).sub(MINIMUM_LIQUIDITY);\n', '            _mint(address(0), MINIMUM_LIQUIDITY);\n', '        } else {\n', '            liquidity = SafeMath.min(\n', '                _flashAmount.mul(totalSupply) / reserveFlashAmount,\n', '                _altAmount.mul(totalSupply) / reserveAltAmount\n', '            );\n', '        }\n', '        require(liquidity > 0, "Pool:: INSUFFICIENT_LIQUIDITY_MINTED");\n', '        _mint(_to, liquidity);\n', '    }\n', '\n', '    function calcNewReserveStake(uint256 _amountIn, uint256 _amountOut) private {\n', '        reserveFlashAmount = reserveFlashAmount.add(_amountIn);\n', '        reserveAltAmount = reserveAltAmount.sub(_amountOut);\n', '    }\n', '\n', '    function calcNewReserveSwap(uint256 _amountIn, uint256 _amountOut) private {\n', '        reserveFlashAmount = reserveFlashAmount.sub(_amountOut);\n', '        reserveAltAmount = reserveAltAmount.add(_amountIn);\n', '    }\n', '\n', '    function calcNewReserveAddLiquidity(uint256 _amountFLASH, uint256 _amountALT) private {\n', '        reserveFlashAmount = reserveFlashAmount.add(_amountFLASH);\n', '        reserveAltAmount = reserveAltAmount.add(_amountALT);\n', '    }\n', '\n', '    function calcNewReserveRemoveLiquidity(uint256 _amountFLASH, uint256 _amountALT) private {\n', '        reserveFlashAmount = reserveFlashAmount.sub(_amountFLASH);\n', '        reserveAltAmount = reserveAltAmount.sub(_amountALT);\n', '    }\n', '}']