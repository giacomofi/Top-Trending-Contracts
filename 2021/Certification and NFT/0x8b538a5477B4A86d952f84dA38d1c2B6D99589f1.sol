['//SPDX-License-Identifier: Unlicense\n', 'pragma solidity ^0.8.0;\n', '\n', 'import "@openzeppelin/contracts/token/ERC20/IERC20.sol";\n', 'import "@openzeppelin/contracts/token/ERC721/IERC721.sol";\n', 'import "@openzeppelin/contracts/token/ERC1155/IERC1155.sol";\n', 'import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";\n', 'import "@openzeppelin/contracts/utils/Address.sol";\n', 'import "@openzeppelin/contracts/access/Ownable.sol";\n', '\n', 'import "./interfaces/INFT20Pair.sol";\n', 'import "./interfaces/INFT20Factory.sol";\n', '\n', 'interface Uni {\n', '    function swapETHForExactTokens(\n', '        uint256 amountOut,\n', '        address[] calldata path,\n', '        address to,\n', '        uint256 deadline\n', '    ) external payable returns (uint256[] memory amounts);\n', '\n', '    function swapExactTokensForETH(\n', '        uint256 amountIn,\n', '        uint256 amountOutMin,\n', '        address[] calldata path,\n', '        address to,\n', '        uint256 deadline\n', '    ) external returns (uint256[] memory amounts);\n', '}\n', '\n', 'contract NFT20Cas is Ownable {\n', '    using SafeERC20 for IERC20;\n', '    using Address for address;\n', '\n', '    address public DEX = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;\n', '    address public WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;\n', '    address public ETH = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;\n', '\n', '    INFT20Factory public NFT20 =\n', '        INFT20Factory(0x0f4676178b5c53Ae0a655f1B19A96387E4b8B5f2);\n', '\n', '    constructor() {}\n', '\n', '    receive() external payable {}\n', '\n', '    function setNFT20(address _registry) public onlyOwner {\n', '        NFT20 = INFT20Factory(_registry);\n', '    }\n', '\n', '    function withdrawEth() public payable {\n', '        address payable _to =\n', '            payable(0x6fBa46974b2b1bEfefA034e236A32e1f10C5A148); //multisig\n', '        (bool sent, ) = _to.call{value: address(this).balance}("");\n', '        require(sent, "Failed to send Ether");\n', '    }\n', '\n', '    //buy\n', '    function ethForNft(\n', '        address _nft,\n', '        uint256[] memory _toIds,\n', '        uint256[] memory _toAmounts,\n', '        address _receipient\n', '    ) public payable {\n', '        uint256 balance_before =\n', '            address(this).balance > msg.value\n', '                ? address(this).balance - msg.value\n', '                : 0;\n', '\n', '        // we get the token\n', '        address token20 = NFT20.nftToToken(_nft);\n', '\n', '        uint256 totalAmount = 0;\n', '        for (uint256 i = 0; i < _toAmounts.length; i++) {\n', '            totalAmount += _toAmounts[i];\n', '        }\n', '\n', '        // calls uniswap contract to swap eth to token20\n', '        swapETHForExactERC20(token20, address(this), totalAmount * 100 ether);\n', '\n', '        // withdraw nft by burning token20\n', '        INFT20Pair(token20).withdraw(_toIds, _toAmounts, _receipient);\n', '\n', '        uint256 balance_after = address(this).balance;\n', '\n', '        uint256 dust = balance_after - balance_before;\n', '        uint256 fees = ((msg.value - dust) * 5) / 100;\n', '\n', '        if (dust - fees > 0) {\n', '            // Return the change ETH back to the user.\n', '            (bool success, ) = _receipient.call{value: dust - fees}("");\n', '            require(success, "swapEthForERC721: ETH dust transfer failed.");\n', '        }\n', '    }\n', '\n', '    // requires setApprovalForAll of NFT contract to this address\n', '    function nftForEth(\n', '        address _nft,\n', '        uint256[] memory _ids,\n', '        uint256[] memory _amounts,\n', '        bool isErc721\n', '    ) external {\n', '        address token20 = NFT20.nftToToken(_nft);\n', '\n', '        if (isErc721) {\n', '            for (uint256 i = 0; i < _ids.length; i++) {\n', '                IERC721(_nft).safeTransferFrom(\n', '                    msg.sender,\n', '                    token20,\n', '                    _ids[i],\n', '                    abi.encodePacked(address(this))\n', '                );\n', '            }\n', '        } else {\n', '            if (_ids.length == 1) {\n', '                IERC1155(_nft).safeTransferFrom(\n', '                    msg.sender,\n', '                    token20,\n', '                    _ids[0],\n', '                    _amounts[0],\n', '                    abi.encodePacked(address(this))\n', '                );\n', '            } else {\n', '                IERC1155(_nft).safeBatchTransferFrom(\n', '                    msg.sender,\n', '                    token20,\n', '                    _ids,\n', '                    _amounts,\n', '                    abi.encodePacked(address(this))\n', '                );\n', '            }\n', '        }\n', '\n', '        // swap the token 20 for eth and send to user\n', '        swapERC20ForExactETH(\n', '            token20,\n', '            msg.sender,\n', '            IERC20(token20).balanceOf(address(this))\n', '        );\n', '    }\n', '\n', '    function swapERC20ForExactETH(\n', '        address _from,\n', '        address _recipient,\n', '        uint256 amount\n', '    ) internal returns (uint256[] memory amounts) {\n', '        uint256 _bal = IERC20(_from).balanceOf(address(this));\n', '        IERC20(_from).safeApprove(DEX, _bal);\n', '\n', '        address[] memory _path = new address[](2);\n', '        _path[0] = _from;\n', '        _path[1] = WETH;\n', '\n', '        uint256[] memory amts =\n', '            Uni(DEX).swapExactTokensForETH(\n', '                amount,\n', '                0,\n', '                _path,\n', '                address(this),\n', '                block.timestamp + 1800\n', '            );\n', '\n', '        payable(_recipient).transfer((amts[1] * 95) / 100);\n', '        return amts;\n', '    }\n', '\n', '    function swapETHForExactERC20(\n', '        address _to,\n', '        address _recipient,\n', '        uint256 _amountOut /* returns (uint256[] memory amounts) */\n', '    ) internal {\n', '        address[] memory _path = new address[](2);\n', '        _path[0] = WETH;\n', '        _path[1] = _to;\n', '\n', '        bytes memory _data =\n', '            abi.encodeWithSelector(\n', '                Uni(DEX).swapETHForExactTokens.selector,\n', '                _amountOut,\n', '                _path,\n', '                _recipient,\n', '                block.timestamp + 1800\n', '            );\n', '\n', '        (bool success, ) = DEX.call{value: msg.value}(_data);\n', '        require(success, "_swapETHForExactERC20: uniswap swap failed.");\n', '    }\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity ^0.8.0;\n', '\n', '/**\n', ' * @dev Interface of the ERC20 standard as defined in the EIP.\n', ' */\n', 'interface IERC20 {\n', '    /**\n', '     * @dev Returns the amount of tokens in existence.\n', '     */\n', '    function totalSupply() external view returns (uint256);\n', '\n', '    /**\n', '     * @dev Returns the amount of tokens owned by `account`.\n', '     */\n', '    function balanceOf(address account) external view returns (uint256);\n', '\n', '    /**\n', "     * @dev Moves `amount` tokens from the caller's account to `recipient`.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transfer(address recipient, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Returns the remaining number of tokens that `spender` will be\n', '     * allowed to spend on behalf of `owner` through {transferFrom}. This is\n', '     * zero by default.\n', '     *\n', '     * This value changes when {approve} or {transferFrom} are called.\n', '     */\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '\n', '    /**\n', "     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * IMPORTANT: Beware that changing an allowance with this method brings the risk\n', '     * that someone may use both the old and the new allowance by unfortunate\n', '     * transaction ordering. One possible solution to mitigate this race\n', "     * condition is to first reduce the spender's allowance to 0 and set the\n", '     * desired value afterwards:\n', '     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '     *\n', '     * Emits an {Approval} event.\n', '     */\n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Moves `amount` tokens from `sender` to `recipient` using the\n', "     * allowance mechanism. `amount` is then deducted from the caller's\n", '     * allowance.\n', '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Emitted when `value` tokens are moved from one account (`from`) to\n', '     * another (`to`).\n', '     *\n', '     * Note that `value` may be zero.\n', '     */\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    /**\n', '     * @dev Emitted when the allowance of a `spender` for an `owner` is set by\n', '     * a call to {approve}. `value` is the new allowance.\n', '     */\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity ^0.8.0;\n', '\n', 'import "../../utils/introspection/IERC165.sol";\n', '\n', '/**\n', ' * @dev Required interface of an ERC721 compliant contract.\n', ' */\n', 'interface IERC721 is IERC165 {\n', '    /**\n', '     * @dev Emitted when `tokenId` token is transferred from `from` to `to`.\n', '     */\n', '    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);\n', '\n', '    /**\n', '     * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.\n', '     */\n', '    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);\n', '\n', '    /**\n', '     * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.\n', '     */\n', '    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);\n', '\n', '    /**\n', "     * @dev Returns the number of tokens in ``owner``'s account.\n", '     */\n', '    function balanceOf(address owner) external view returns (uint256 balance);\n', '\n', '    /**\n', '     * @dev Returns the owner of the `tokenId` token.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - `tokenId` must exist.\n', '     */\n', '    function ownerOf(uint256 tokenId) external view returns (address owner);\n', '\n', '    /**\n', '     * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients\n', '     * are aware of the ERC721 protocol to prevent tokens from being forever locked.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - `from` cannot be the zero address.\n', '     * - `to` cannot be the zero address.\n', '     * - `tokenId` token must exist and be owned by `from`.\n', '     * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.\n', '     * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function safeTransferFrom(address from, address to, uint256 tokenId) external;\n', '\n', '    /**\n', '     * @dev Transfers `tokenId` token from `from` to `to`.\n', '     *\n', '     * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - `from` cannot be the zero address.\n', '     * - `to` cannot be the zero address.\n', '     * - `tokenId` token must be owned by `from`.\n', '     * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transferFrom(address from, address to, uint256 tokenId) external;\n', '\n', '    /**\n', '     * @dev Gives permission to `to` to transfer `tokenId` token to another account.\n', '     * The approval is cleared when the token is transferred.\n', '     *\n', '     * Only a single account can be approved at a time, so approving the zero address clears previous approvals.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The caller must own the token or be an approved operator.\n', '     * - `tokenId` must exist.\n', '     *\n', '     * Emits an {Approval} event.\n', '     */\n', '    function approve(address to, uint256 tokenId) external;\n', '\n', '    /**\n', '     * @dev Returns the account approved for `tokenId` token.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - `tokenId` must exist.\n', '     */\n', '    function getApproved(uint256 tokenId) external view returns (address operator);\n', '\n', '    /**\n', '     * @dev Approve or remove `operator` as an operator for the caller.\n', '     * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The `operator` cannot be the caller.\n', '     *\n', '     * Emits an {ApprovalForAll} event.\n', '     */\n', '    function setApprovalForAll(address operator, bool _approved) external;\n', '\n', '    /**\n', '     * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.\n', '     *\n', '     * See {setApprovalForAll}\n', '     */\n', '    function isApprovedForAll(address owner, address operator) external view returns (bool);\n', '\n', '    /**\n', '      * @dev Safely transfers `tokenId` token from `from` to `to`.\n', '      *\n', '      * Requirements:\n', '      *\n', '      * - `from` cannot be the zero address.\n', '      * - `to` cannot be the zero address.\n', '      * - `tokenId` token must exist and be owned by `from`.\n', '      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.\n', '      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.\n', '      *\n', '      * Emits a {Transfer} event.\n', '      */\n', '    function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity ^0.8.0;\n', '\n', 'import "../../utils/introspection/IERC165.sol";\n', '\n', '/**\n', ' * @dev Required interface of an ERC1155 compliant contract, as defined in the\n', ' * https://eips.ethereum.org/EIPS/eip-1155[EIP].\n', ' *\n', ' * _Available since v3.1._\n', ' */\n', 'interface IERC1155 is IERC165 {\n', '    /**\n', '     * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.\n', '     */\n', '    event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);\n', '\n', '    /**\n', '     * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all\n', '     * transfers.\n', '     */\n', '    event TransferBatch(address indexed operator, address indexed from, address indexed to, uint256[] ids, uint256[] values);\n', '\n', '    /**\n', '     * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to\n', '     * `approved`.\n', '     */\n', '    event ApprovalForAll(address indexed account, address indexed operator, bool approved);\n', '\n', '    /**\n', '     * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.\n', '     *\n', '     * If an {URI} event was emitted for `id`, the standard\n', '     * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value\n', '     * returned by {IERC1155MetadataURI-uri}.\n', '     */\n', '    event URI(string value, uint256 indexed id);\n', '\n', '    /**\n', '     * @dev Returns the amount of tokens of token type `id` owned by `account`.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - `account` cannot be the zero address.\n', '     */\n', '    function balanceOf(address account, uint256 id) external view returns (uint256);\n', '\n', '    /**\n', '     * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - `accounts` and `ids` must have the same length.\n', '     */\n', '    function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids) external view returns (uint256[] memory);\n', '\n', '    /**\n', "     * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,\n", '     *\n', '     * Emits an {ApprovalForAll} event.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - `operator` cannot be the caller.\n', '     */\n', '    function setApprovalForAll(address operator, bool approved) external;\n', '\n', '    /**\n', "     * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.\n", '     *\n', '     * See {setApprovalForAll}.\n', '     */\n', '    function isApprovedForAll(address account, address operator) external view returns (bool);\n', '\n', '    /**\n', '     * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.\n', '     *\n', '     * Emits a {TransferSingle} event.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - `to` cannot be the zero address.\n', "     * - If the caller is not `from`, it must be have been approved to spend ``from``'s tokens via {setApprovalForAll}.\n", '     * - `from` must have a balance of tokens of type `id` of at least `amount`.\n', '     * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the\n', '     * acceptance magic value.\n', '     */\n', '    function safeTransferFrom(address from, address to, uint256 id, uint256 amount, bytes calldata data) external;\n', '\n', '    /**\n', '     * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.\n', '     *\n', '     * Emits a {TransferBatch} event.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - `ids` and `amounts` must have the same length.\n', '     * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the\n', '     * acceptance magic value.\n', '     */\n', '    function safeBatchTransferFrom(address from, address to, uint256[] calldata ids, uint256[] calldata amounts, bytes calldata data) external;\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity ^0.8.0;\n', '\n', 'import "../IERC20.sol";\n', 'import "../../../utils/Address.sol";\n', '\n', '/**\n', ' * @title SafeERC20\n', ' * @dev Wrappers around ERC20 operations that throw on failure (when the token\n', ' * contract returns false). Tokens that return no value (and instead revert or\n', ' * throw on failure) are also supported, non-reverting calls are assumed to be\n', ' * successful.\n', ' * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,\n', ' * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.\n', ' */\n', 'library SafeERC20 {\n', '    using Address for address;\n', '\n', '    function safeTransfer(IERC20 token, address to, uint256 value) internal {\n', '        _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));\n', '    }\n', '\n', '    function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {\n', '        _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));\n', '    }\n', '\n', '    /**\n', '     * @dev Deprecated. This function has issues similar to the ones found in\n', '     * {IERC20-approve}, and its usage is discouraged.\n', '     *\n', '     * Whenever possible, use {safeIncreaseAllowance} and\n', '     * {safeDecreaseAllowance} instead.\n', '     */\n', '    function safeApprove(IERC20 token, address spender, uint256 value) internal {\n', '        // safeApprove should only be called when setting an initial allowance,\n', '        // or when resetting it to zero. To increase and decrease it, use\n', "        // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'\n", '        // solhint-disable-next-line max-line-length\n', '        require((value == 0) || (token.allowance(address(this), spender) == 0),\n', '            "SafeERC20: approve from non-zero to non-zero allowance"\n', '        );\n', '        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));\n', '    }\n', '\n', '    function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {\n', '        uint256 newAllowance = token.allowance(address(this), spender) + value;\n', '        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));\n', '    }\n', '\n', '    function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {\n', '        unchecked {\n', '            uint256 oldAllowance = token.allowance(address(this), spender);\n', '            require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");\n', '            uint256 newAllowance = oldAllowance - value;\n', '            _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));\n', '        }\n', '    }\n', '\n', '    /**\n', '     * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement\n', '     * on the return value: the return value is optional (but if data is returned, it must not be false).\n', '     * @param token The token targeted by the call.\n', '     * @param data The call data (encoded using abi.encode or one of its variants).\n', '     */\n', '    function _callOptionalReturn(IERC20 token, bytes memory data) private {\n', "        // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since\n", "        // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that\n", '        // the target address contains contract code and also asserts for success in the low-level call.\n', '\n', '        bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");\n', '        if (returndata.length > 0) { // Return data is optional\n', '            // solhint-disable-next-line max-line-length\n', '            require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");\n', '        }\n', '    }\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity ^0.8.0;\n', '\n', '/**\n', ' * @dev Collection of functions related to the address type\n', ' */\n', 'library Address {\n', '    /**\n', '     * @dev Returns true if `account` is a contract.\n', '     *\n', '     * [IMPORTANT]\n', '     * ====\n', '     * It is unsafe to assume that an address for which this function returns\n', '     * false is an externally-owned account (EOA) and not a contract.\n', '     *\n', '     * Among others, `isContract` will return false for the following\n', '     * types of addresses:\n', '     *\n', '     *  - an externally-owned account\n', '     *  - a contract in construction\n', '     *  - an address where a contract will be created\n', '     *  - an address where a contract lived, but was destroyed\n', '     * ====\n', '     */\n', '    function isContract(address account) internal view returns (bool) {\n', '        // This method relies on extcodesize, which returns 0 for contracts in\n', '        // construction, since the code is only stored at the end of the\n', '        // constructor execution.\n', '\n', '        uint256 size;\n', '        // solhint-disable-next-line no-inline-assembly\n', '        assembly { size := extcodesize(account) }\n', '        return size > 0;\n', '    }\n', '\n', '    /**\n', "     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to\n", '     * `recipient`, forwarding all available gas and reverting on errors.\n', '     *\n', '     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost\n', '     * of certain opcodes, possibly making contracts go over the 2300 gas limit\n', '     * imposed by `transfer`, making them unable to receive funds via\n', '     * `transfer`. {sendValue} removes this limitation.\n', '     *\n', '     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].\n', '     *\n', '     * IMPORTANT: because control is transferred to `recipient`, care must be\n', '     * taken to not create reentrancy vulnerabilities. Consider using\n', '     * {ReentrancyGuard} or the\n', '     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].\n', '     */\n', '    function sendValue(address payable recipient, uint256 amount) internal {\n', '        require(address(this).balance >= amount, "Address: insufficient balance");\n', '\n', '        // solhint-disable-next-line avoid-low-level-calls, avoid-call-value\n', '        (bool success, ) = recipient.call{ value: amount }("");\n', '        require(success, "Address: unable to send value, recipient may have reverted");\n', '    }\n', '\n', '    /**\n', '     * @dev Performs a Solidity function call using a low level `call`. A\n', '     * plain`call` is an unsafe replacement for a function call: use this\n', '     * function instead.\n', '     *\n', '     * If `target` reverts with a revert reason, it is bubbled up by this\n', '     * function (like regular Solidity function calls).\n', '     *\n', '     * Returns the raw returned data. To convert to the expected return value,\n', '     * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - `target` must be a contract.\n', '     * - calling `target` with `data` must not revert.\n', '     *\n', '     * _Available since v3.1._\n', '     */\n', '    function functionCall(address target, bytes memory data) internal returns (bytes memory) {\n', '      return functionCall(target, data, "Address: low-level call failed");\n', '    }\n', '\n', '    /**\n', '     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with\n', '     * `errorMessage` as a fallback revert reason when `target` reverts.\n', '     *\n', '     * _Available since v3.1._\n', '     */\n', '    function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {\n', '        return functionCallWithValue(target, data, 0, errorMessage);\n', '    }\n', '\n', '    /**\n', '     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],\n', '     * but also transferring `value` wei to `target`.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - the calling contract must have an ETH balance of at least `value`.\n', '     * - the called Solidity function must be `payable`.\n', '     *\n', '     * _Available since v3.1._\n', '     */\n', '    function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {\n', '        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");\n', '    }\n', '\n', '    /**\n', '     * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but\n', '     * with `errorMessage` as a fallback revert reason when `target` reverts.\n', '     *\n', '     * _Available since v3.1._\n', '     */\n', '    function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {\n', '        require(address(this).balance >= value, "Address: insufficient balance for call");\n', '        require(isContract(target), "Address: call to non-contract");\n', '\n', '        // solhint-disable-next-line avoid-low-level-calls\n', '        (bool success, bytes memory returndata) = target.call{ value: value }(data);\n', '        return _verifyCallResult(success, returndata, errorMessage);\n', '    }\n', '\n', '    /**\n', '     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],\n', '     * but performing a static call.\n', '     *\n', '     * _Available since v3.3._\n', '     */\n', '    function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {\n', '        return functionStaticCall(target, data, "Address: low-level static call failed");\n', '    }\n', '\n', '    /**\n', '     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],\n', '     * but performing a static call.\n', '     *\n', '     * _Available since v3.3._\n', '     */\n', '    function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {\n', '        require(isContract(target), "Address: static call to non-contract");\n', '\n', '        // solhint-disable-next-line avoid-low-level-calls\n', '        (bool success, bytes memory returndata) = target.staticcall(data);\n', '        return _verifyCallResult(success, returndata, errorMessage);\n', '    }\n', '\n', '    /**\n', '     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],\n', '     * but performing a delegate call.\n', '     *\n', '     * _Available since v3.4._\n', '     */\n', '    function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {\n', '        return functionDelegateCall(target, data, "Address: low-level delegate call failed");\n', '    }\n', '\n', '    /**\n', '     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],\n', '     * but performing a delegate call.\n', '     *\n', '     * _Available since v3.4._\n', '     */\n', '    function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {\n', '        require(isContract(target), "Address: delegate call to non-contract");\n', '\n', '        // solhint-disable-next-line avoid-low-level-calls\n', '        (bool success, bytes memory returndata) = target.delegatecall(data);\n', '        return _verifyCallResult(success, returndata, errorMessage);\n', '    }\n', '\n', '    function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {\n', '        if (success) {\n', '            return returndata;\n', '        } else {\n', '            // Look for revert reason and bubble it up if present\n', '            if (returndata.length > 0) {\n', '                // The easiest way to bubble the revert reason is using memory via assembly\n', '\n', '                // solhint-disable-next-line no-inline-assembly\n', '                assembly {\n', '                    let returndata_size := mload(returndata)\n', '                    revert(add(32, returndata), returndata_size)\n', '                }\n', '            } else {\n', '                revert(errorMessage);\n', '            }\n', '        }\n', '    }\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity ^0.8.0;\n', '\n', 'import "../utils/Context.sol";\n', '/**\n', ' * @dev Contract module which provides a basic access control mechanism, where\n', ' * there is an account (an owner) that can be granted exclusive access to\n', ' * specific functions.\n', ' *\n', ' * By default, the owner account will be the one that deploys the contract. This\n', ' * can later be changed with {transferOwnership}.\n', ' *\n', ' * This module is used through inheritance. It will make available the modifier\n', ' * `onlyOwner`, which can be applied to your functions to restrict their use to\n', ' * the owner.\n', ' */\n', 'abstract contract Ownable is Context {\n', '    address private _owner;\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    /**\n', '     * @dev Initializes the contract setting the deployer as the initial owner.\n', '     */\n', '    constructor () {\n', '        address msgSender = _msgSender();\n', '        _owner = msgSender;\n', '        emit OwnershipTransferred(address(0), msgSender);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the address of the current owner.\n', '     */\n', '    function owner() public view virtual returns (address) {\n', '        return _owner;\n', '    }\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(owner() == _msgSender(), "Ownable: caller is not the owner");\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Leaves the contract without owner. It will not be possible to call\n', '     * `onlyOwner` functions anymore. Can only be called by the current owner.\n', '     *\n', '     * NOTE: Renouncing ownership will leave the contract without an owner,\n', '     * thereby removing any functionality that is only available to the owner.\n', '     */\n', '    function renounceOwnership() public virtual onlyOwner {\n', '        emit OwnershipTransferred(_owner, address(0));\n', '        _owner = address(0);\n', '    }\n', '\n', '    /**\n', '     * @dev Transfers ownership of the contract to a new account (`newOwner`).\n', '     * Can only be called by the current owner.\n', '     */\n', '    function transferOwnership(address newOwner) public virtual onlyOwner {\n', '        require(newOwner != address(0), "Ownable: new owner is the zero address");\n', '        emit OwnershipTransferred(_owner, newOwner);\n', '        _owner = newOwner;\n', '    }\n', '}\n', '\n', '//SPDX-License-Identifier: Unlicense\n', '\n', 'pragma solidity ^0.8.0;\n', '\n', 'interface INFT20Pair {\n', '    function withdraw(\n', '        uint256[] calldata _tokenIds,\n', '        uint256[] calldata amounts,\n', '        address recipient\n', '    ) external;\n', '\n', '    function withdraw(uint256[] calldata _tokenIds, uint256[] calldata amounts)\n', '        external;\n', '\n', '    function track1155(uint256 _tokenId) external returns (uint256);\n', '\n', '    function swap721(uint256 _in, uint256 _out) external;\n', '\n', '    function swap1155(\n', '        uint256[] calldata in_ids,\n', '        uint256[] calldata in_amounts,\n', '        uint256[] calldata out_ids,\n', '        uint256[] calldata out_amounts\n', '    ) external;\n', '}\n', '\n', '//SPDX-License-Identifier: Unlicense\n', '\n', 'pragma solidity ^0.8.0;\n', '\n', 'interface INFT20Factory {\n', '\n', '    function nftToToken(address pair) external returns (address);\n', '\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity ^0.8.0;\n', '\n', '/**\n', ' * @dev Interface of the ERC165 standard, as defined in the\n', ' * https://eips.ethereum.org/EIPS/eip-165[EIP].\n', ' *\n', ' * Implementers can declare support of contract interfaces, which can then be\n', ' * queried by others ({ERC165Checker}).\n', ' *\n', ' * For an implementation, see {ERC165}.\n', ' */\n', 'interface IERC165 {\n', '    /**\n', '     * @dev Returns true if this contract implements the interface defined by\n', '     * `interfaceId`. See the corresponding\n', '     * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]\n', '     * to learn more about how these ids are created.\n', '     *\n', '     * This function call must use less than 30 000 gas.\n', '     */\n', '    function supportsInterface(bytes4 interfaceId) external view returns (bool);\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity ^0.8.0;\n', '\n', '/*\n', ' * @dev Provides information about the current execution context, including the\n', ' * sender of the transaction and its data. While these are generally available\n', ' * via msg.sender and msg.data, they should not be accessed in such a direct\n', ' * manner, since when dealing with meta-transactions the account sending and\n', ' * paying for execution may not be the actual sender (as far as an application\n', ' * is concerned).\n', ' *\n', ' * This contract is only required for intermediate, library-like contracts.\n', ' */\n', 'abstract contract Context {\n', '    function _msgSender() internal view virtual returns (address) {\n', '        return msg.sender;\n', '    }\n', '\n', '    function _msgData() internal view virtual returns (bytes calldata) {\n', '        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691\n', '        return msg.data;\n', '    }\n', '}\n', '\n', '{\n', '  "optimizer": {\n', '    "enabled": true,\n', '    "runs": 200\n', '  },\n', '  "outputSelection": {\n', '    "*": {\n', '      "*": [\n', '        "evm.bytecode",\n', '        "evm.deployedBytecode",\n', '        "abi"\n', '      ]\n', '    }\n', '  },\n', '  "libraries": {}\n', '}']