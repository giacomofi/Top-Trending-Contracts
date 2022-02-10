['// SPDX-License-Identifier: MIT\n', 'pragma solidity ^0.7.6;\n', '\n', 'import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";\n', 'import {IERC721} from "@openzeppelin/contracts/token/ERC721/IERC721.sol";\n', 'import "./libraries/CloneLibrary.sol";\n', '\n', '\n', '/// @author Alchemy Team\n', '/// @title AlchemyFactory\n', '/// @notice Factory contract to create new instances of Alchemy\n', 'contract AlchemyFactory {\n', '    using CloneLibrary for address;\n', '\n', '    // event that is emitted when a new Alchemy Contract was minted\n', '    event NewAlchemy(address alchemy, address governor, address timelock);\n', '\n', '    // the Alchemy governance token\n', '    IERC20 public alch;\n', '\n', '    // the factory owner\n', '    address payable public factoryOwner;\n', '    address payable public alchemyRouter;\n', '    address public alchemyImplementation;\n', '    address public governorAlphaImplementation;\n', '    address public timelockImplementation;\n', '\n', '    constructor(\n', '        IERC20 _alch,\n', '        address _alchemyImplementation,\n', '        address _governorAlphaImplementation,\n', '        address _timelockImplementation,\n', '        address payable _alchemyRouter\n', '    )\n', '    {\n', '        alch = _alch;\n', '        factoryOwner = msg.sender;\n', '        alchemyImplementation = _alchemyImplementation;\n', '        governorAlphaImplementation = _governorAlphaImplementation;\n', '        timelockImplementation = _timelockImplementation;\n', '        alchemyRouter =_alchemyRouter;\n', '    }\n', '\n', '    /**\n', '     * @dev distributes the ALCH token supply\n', '     *\n', '     * @param amount the amount to distribute\n', '    */\n', '    function distributeAlch(uint amount) internal {\n', '        if (alch.balanceOf(address(this)) >= amount) {\n', '            alch.transfer(msg.sender, amount);\n', '        }\n', '    }\n', '\n', '    /**\n', '     * @dev mints a new Alchemy Contract\n', '     *\n', '     * @param nftAddress_ the initial nft address to add to the contract\n', '     * @param owner_ the owner of the contract\n', '     * @param tokenId_ the token id of the nft to be added\n', '     * @param totalSupply_ the total supply of the erc20\n', '     * @param name_ the token name\n', '     * @param symbol_ the token symbol\n', '     * @param buyoutPrice_ the buyout price to buyout the dao\n', '     * @param votingPeriod_ the voting period for the DAO in blocks\n', '     * @param timelockDelay_ the timelock delay in seconds\n', '     * @return alchemy - the address of the newly generated alchemy contract\n', '     * governor - the address of the new governor alpha\n', '     * timelock - the address of the new timelock\n', '    */\n', '    function NFTDAOMint(\n', '        IERC721 nftAddress_,\n', '        address owner_,\n', '        uint256 tokenId_,\n', '        uint256 totalSupply_,\n', '        string memory name_,\n', '        string memory symbol_,\n', '        uint256 buyoutPrice_,\n', '        uint256 votingPeriod_,\n', '        uint256 timelockDelay_\n', '    ) public returns (address alchemy, address governor, address timelock) {\n', '        alchemy = alchemyImplementation.createClone();\n', '        governor = governorAlphaImplementation.createClone();\n', '        timelock = timelockImplementation.createClone();\n', '\n', '        nftAddress_.transferFrom(msg.sender, alchemy, tokenId_);\n', '\n', '        IGovernorAlpha(governor).initialize(\n', '            alchemy,\n', '            timelock,\n', '            totalSupply_,\n', '            votingPeriod_\n', '        );\n', '\n', '        ITimelock(timelock).initialize(governor, timelockDelay_);\n', '\n', '        IAlchemy(alchemy).initialize(\n', '            nftAddress_,\n', '            owner_,\n', '            tokenId_,\n', '            totalSupply_,\n', '            name_,\n', '            symbol_,\n', '            buyoutPrice_,\n', '            address(this),\n', '            governor,\n', '            timelock\n', '        );\n', '\n', '        // distribute gov token\n', '        distributeAlch(100 * 10 ** 18);\n', '\n', '        emit NewAlchemy(alchemy, governor, timelock);\n', '    }\n', '\n', '    /**\n', '     * @dev lets the owner transfer alch token to another address\n', '     *\n', '     * @param dst the address to send the tokens\n', '     * @param amount the token amount\n', '    */\n', '    function transferAlch(address dst, uint256 amount) external {\n', '        require(msg.sender == factoryOwner, "Only owner");\n', '        alch.transfer(dst, amount);\n', '    }\n', '\n', '    /**\n', '     * @dev lets the owner change the ownership to another address\n', '     *\n', '     * @param newOwner the address of the new owner\n', '    */\n', '    function newFactoryOwner(address payable newOwner) external {\n', '        require(msg.sender == factoryOwner, "Only owner");\n', '        factoryOwner = newOwner;\n', '    }\n', '\n', '    /**\n', '     * @dev lets the owner change the address to another address\n', '     *\n', '     * @param newAlchemyImplementation_ the new address\n', '    */\n', '    function newAlchemyImplementation(address newAlchemyImplementation_) external {\n', '        require(msg.sender == factoryOwner, "Only owner");\n', '        alchemyImplementation = newAlchemyImplementation_;\n', '    }\n', '\n', '    /**\n', '     * @dev lets the owner change the address to another address\n', '     *\n', '     * @param newGovernorAlphaImplementation_ the new address\n', '    */\n', '    function newGovernorAlphaImplementation(address newGovernorAlphaImplementation_) external {\n', '        require(msg.sender == factoryOwner, "Only owner");\n', '        governorAlphaImplementation = newGovernorAlphaImplementation_;\n', '    }\n', '\n', '    /**\n', '     * @dev lets the owner change the address to another address\n', '     *\n', '     * @param newTimelockImplementation_ the new address\n', '    */\n', '    function newTimelockImplementation(address newTimelockImplementation_) external {\n', '        require(msg.sender == factoryOwner, "Only owner");\n', '        timelockImplementation = newTimelockImplementation_;\n', '    }\n', '\n', '    /**\n', '     * @dev lets the owner change the address to another address\n', '     *\n', '     * @param newRouter the address of the new router\n', '    */\n', '    function newAlchemyRouter(address payable newRouter) external {\n', '        require(msg.sender == factoryOwner, "Only owner");\n', '        alchemyRouter = newRouter;\n', '    }\n', '\n', '    /**\n', '     * @dev gets the address of the current alchemy router\n', '     *\n', '     * @return the address of the alchemy router\n', '    */\n', '    function getAlchemyRouter() public view returns (address payable) {\n', '        return alchemyRouter;\n', '    }\n', '}\n', '\n', '\n', 'interface IAlchemy {\n', '    function initialize(\n', '        IERC721 nftAddress_,\n', '        address owner_,\n', '        uint256 tokenId_,\n', '        uint256 totalSupply_,\n', '        string memory name_,\n', '        string memory symbol_,\n', '        uint256 buyoutPrice_,\n', '        address factoryContract,\n', '        address governor_,\n', '        address timelock_\n', '    ) external;\n', '}\n', '\n', '\n', 'interface IGovernorAlpha {\n', '    function initialize(\n', '        address nft_,\n', '        address timelock_,\n', '        uint supply_,\n', '        uint votingPeriod_\n', '    ) external;\n', '}\n', '\n', '\n', 'interface ITimelock {\n', '    function initialize(address admin_, uint delay_) external;\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity >=0.6.0 <0.8.0;\n', '\n', '/**\n', ' * @dev Interface of the ERC20 standard as defined in the EIP.\n', ' */\n', 'interface IERC20 {\n', '    /**\n', '     * @dev Returns the amount of tokens in existence.\n', '     */\n', '    function totalSupply() external view returns (uint256);\n', '\n', '    /**\n', '     * @dev Returns the amount of tokens owned by `account`.\n', '     */\n', '    function balanceOf(address account) external view returns (uint256);\n', '\n', '    /**\n', "     * @dev Moves `amount` tokens from the caller's account to `recipient`.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transfer(address recipient, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Returns the remaining number of tokens that `spender` will be\n', '     * allowed to spend on behalf of `owner` through {transferFrom}. This is\n', '     * zero by default.\n', '     *\n', '     * This value changes when {approve} or {transferFrom} are called.\n', '     */\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '\n', '    /**\n', "     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * IMPORTANT: Beware that changing an allowance with this method brings the risk\n', '     * that someone may use both the old and the new allowance by unfortunate\n', '     * transaction ordering. One possible solution to mitigate this race\n', "     * condition is to first reduce the spender's allowance to 0 and set the\n", '     * desired value afterwards:\n', '     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '     *\n', '     * Emits an {Approval} event.\n', '     */\n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Moves `amount` tokens from `sender` to `recipient` using the\n', "     * allowance mechanism. `amount` is then deducted from the caller's\n", '     * allowance.\n', '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Emitted when `value` tokens are moved from one account (`from`) to\n', '     * another (`to`).\n', '     *\n', '     * Note that `value` may be zero.\n', '     */\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    /**\n', '     * @dev Emitted when the allowance of a `spender` for an `owner` is set by\n', '     * a call to {approve}. `value` is the new allowance.\n', '     */\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity >=0.6.2 <0.8.0;\n', '\n', 'import "../../introspection/IERC165.sol";\n', '\n', '/**\n', ' * @dev Required interface of an ERC721 compliant contract.\n', ' */\n', 'interface IERC721 is IERC165 {\n', '    /**\n', '     * @dev Emitted when `tokenId` token is transferred from `from` to `to`.\n', '     */\n', '    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);\n', '\n', '    /**\n', '     * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.\n', '     */\n', '    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);\n', '\n', '    /**\n', '     * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.\n', '     */\n', '    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);\n', '\n', '    /**\n', "     * @dev Returns the number of tokens in ``owner``'s account.\n", '     */\n', '    function balanceOf(address owner) external view returns (uint256 balance);\n', '\n', '    /**\n', '     * @dev Returns the owner of the `tokenId` token.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - `tokenId` must exist.\n', '     */\n', '    function ownerOf(uint256 tokenId) external view returns (address owner);\n', '\n', '    /**\n', '     * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients\n', '     * are aware of the ERC721 protocol to prevent tokens from being forever locked.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - `from` cannot be the zero address.\n', '     * - `to` cannot be the zero address.\n', '     * - `tokenId` token must exist and be owned by `from`.\n', '     * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.\n', '     * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function safeTransferFrom(address from, address to, uint256 tokenId) external;\n', '\n', '    /**\n', '     * @dev Transfers `tokenId` token from `from` to `to`.\n', '     *\n', '     * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - `from` cannot be the zero address.\n', '     * - `to` cannot be the zero address.\n', '     * - `tokenId` token must be owned by `from`.\n', '     * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transferFrom(address from, address to, uint256 tokenId) external;\n', '\n', '    /**\n', '     * @dev Gives permission to `to` to transfer `tokenId` token to another account.\n', '     * The approval is cleared when the token is transferred.\n', '     *\n', '     * Only a single account can be approved at a time, so approving the zero address clears previous approvals.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The caller must own the token or be an approved operator.\n', '     * - `tokenId` must exist.\n', '     *\n', '     * Emits an {Approval} event.\n', '     */\n', '    function approve(address to, uint256 tokenId) external;\n', '\n', '    /**\n', '     * @dev Returns the account approved for `tokenId` token.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - `tokenId` must exist.\n', '     */\n', '    function getApproved(uint256 tokenId) external view returns (address operator);\n', '\n', '    /**\n', '     * @dev Approve or remove `operator` as an operator for the caller.\n', '     * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The `operator` cannot be the caller.\n', '     *\n', '     * Emits an {ApprovalForAll} event.\n', '     */\n', '    function setApprovalForAll(address operator, bool _approved) external;\n', '\n', '    /**\n', '     * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.\n', '     *\n', '     * See {setApprovalForAll}\n', '     */\n', '    function isApprovedForAll(address owner, address operator) external view returns (bool);\n', '\n', '    /**\n', '      * @dev Safely transfers `tokenId` token from `from` to `to`.\n', '      *\n', '      * Requirements:\n', '      *\n', '      * - `from` cannot be the zero address.\n', '      * - `to` cannot be the zero address.\n', '      * - `tokenId` token must exist and be owned by `from`.\n', '      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.\n', '      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.\n', '      *\n', '      * Emits a {Transfer} event.\n', '      */\n', '    function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', 'pragma solidity ^0.7.0;\n', '\n', '/*\n', 'The MIT License (MIT)\n', 'Copyright (c) 2018 Murray Software, LLC.\n', 'Permission is hereby granted, free of charge, to any person obtaining\n', 'a copy of this software and associated documentation files (the\n', '"Software"), to deal in the Software without restriction, including\n', 'without limitation the rights to use, copy, modify, merge, publish,\n', 'distribute, sublicense, and/or sell copies of the Software, and to\n', 'permit persons to whom the Software is furnished to do so, subject to\n', 'the following conditions:\n', 'The above copyright notice and this permission notice shall be included\n', 'in all copies or substantial portions of the Software.\n', 'THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS\n', 'OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF\n', 'MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.\n', 'IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY\n', 'CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,\n', 'TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE\n', 'SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.\n', '*/\n', '//solhint-disable max-line-length\n', '//solhint-disable no-inline-assembly\n', '\n', '\n', '/**\n', ' * EIP 1167 Proxy Deployment\n', ' * Originally from https://github.com/optionality/clone-factory/\n', ' */\n', 'library CloneLibrary {\n', '\n', '    function createClone(address target) internal returns (address result) {\n', '        // Reserve 55 bytes for the deploy code + 17 bytes as a buffer to prevent overwriting\n', '        // other memory in the final mstore\n', '        bytes memory cloneBuffer = new bytes(72);\n', '        assembly {\n', '            let clone := add(cloneBuffer, 32)\n', '            mstore(clone, 0x3d602d80600a3d3981f3363d3d373d3d3d363d73000000000000000000000000)\n', '            mstore(add(clone, 0x14), shl(96, target))\n', '            mstore(add(clone, 0x28), 0x5af43d82803e903d91602b57fd5bf30000000000000000000000000000000000)\n', '            result := create(0, clone, 0x37)\n', '        }\n', '    }\n', '\n', '\n', '    function isClone(address target, address query) internal view returns (bool result) {\n', '        assembly {\n', '            let clone := mload(0x40)\n', '            mstore(clone, 0x363d3d373d3d3d363d7300000000000000000000000000000000000000000000)\n', '            mstore(add(clone, 0xa), shl(96, target))\n', '            mstore(add(clone, 0x1e), 0x5af43d82803e903d91602b57fd5bf30000000000000000000000000000000000)\n', '\n', '            let other := add(clone, 0x40)\n', '            extcodecopy(query, other, 0, 0x2d)\n', '            result := and(\n', '                eq(mload(clone), mload(other)),\n', '                eq(mload(add(clone, 0xd)), mload(add(other, 0xd)))\n', '            )\n', '        }\n', '    }\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity >=0.6.0 <0.8.0;\n', '\n', '/**\n', ' * @dev Interface of the ERC165 standard, as defined in the\n', ' * https://eips.ethereum.org/EIPS/eip-165[EIP].\n', ' *\n', ' * Implementers can declare support of contract interfaces, which can then be\n', ' * queried by others ({ERC165Checker}).\n', ' *\n', ' * For an implementation, see {ERC165}.\n', ' */\n', 'interface IERC165 {\n', '    /**\n', '     * @dev Returns true if this contract implements the interface defined by\n', '     * `interfaceId`. See the corresponding\n', '     * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]\n', '     * to learn more about how these ids are created.\n', '     *\n', '     * This function call must use less than 30 000 gas.\n', '     */\n', '    function supportsInterface(bytes4 interfaceId) external view returns (bool);\n', '}\n', '\n', '{\n', '  "optimizer": {\n', '    "enabled": false,\n', '    "runs": 200\n', '  },\n', '  "outputSelection": {\n', '    "*": {\n', '      "*": [\n', '        "evm.bytecode",\n', '        "evm.deployedBytecode",\n', '        "abi"\n', '      ]\n', '    }\n', '  },\n', '  "libraries": {}\n', '}']