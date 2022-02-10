['/**\n', ' *Submitted for verification at Etherscan.io on 2021-07-07\n', '*/\n', '\n', '// SPDX-License-Identifier: GPL-3.0-or-later\n', 'pragma solidity 0.8.5;\n', '\n', 'interface IERC721 {\n', '    event Transfer(\n', '        address indexed from,\n', '        address indexed to,\n', '        uint256 indexed tokenId\n', '    );\n', '    event Approval(\n', '        address indexed owner,\n', '        address indexed approved,\n', '        uint256 indexed tokenId\n', '    );\n', '    event ApprovalForAll(\n', '        address indexed owner,\n', '        address indexed operator,\n', '        bool approved\n', '    );\n', '\n', '    function balanceOf(address owner) external view returns (uint256 balance);\n', '\n', '    function ownerOf(uint256 tokenId) external view returns (address owner);\n', '\n', '    function safeTransferFrom(\n', '        address from,\n', '        address to,\n', '        uint256 tokenId\n', '    ) external;\n', '\n', '    function transferFrom(\n', '        address from,\n', '        address to,\n', '        uint256 tokenId\n', '    ) external;\n', '\n', '    function approve(address to, uint256 tokenId) external;\n', '\n', '    function getApproved(uint256 tokenId)\n', '        external\n', '        view\n', '        returns (address operator);\n', '\n', '    function setApprovalForAll(address operator, bool _approved) external;\n', '\n', '    function isApprovedForAll(address owner, address operator)\n', '        external\n', '        view\n', '        returns (bool);\n', '\n', '    function safeTransferFrom(\n', '        address from,\n', '        address to,\n', '        uint256 tokenId,\n', '        bytes calldata data\n', '    ) external;\n', '}\n', '\n', 'interface IERC721Metadata {\n', '    function name() external view returns (string memory);\n', '\n', '    function symbol() external view returns (string memory);\n', '\n', '    function tokenURI(uint256 tokenId) external view returns (string memory);\n', '}\n', '\n', 'interface IERC721Receiver {\n', '    function onERC721Received(\n', '        address operator,\n', '        address from,\n', '        uint256 tokenId,\n', '        bytes calldata data\n', '    ) external returns (bytes4);\n', '}\n', '\n', 'interface IERC165 {\n', '    function supportsInterface(bytes4 interfaceId) external view returns (bool);\n', '}\n', '\n', 'abstract contract ERC165 is IERC165 {\n', '    function supportsInterface(bytes4 interfaceId)\n', '        public\n', '        view\n', '        virtual\n', '        override\n', '        returns (bool)\n', '    {\n', '        return interfaceId == type(IERC165).interfaceId;\n', '    }\n', '}\n', '\n', '/**\n', ' * Based on: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/ERC721.sol\n', ' */\n', 'contract ERC721 is ERC165, IERC721 {\n', '    mapping(uint256 => address) private _owners;\n', '    mapping(address => uint256) private _balances;\n', '    mapping(uint256 => address) private _tokenApprovals;\n', '    mapping(address => mapping(address => bool)) private _operatorApprovals;\n', '\n', '    function supportsInterface(bytes4 interfaceId)\n', '        public\n', '        view\n', '        virtual\n', '        override\n', '        returns (bool)\n', '    {\n', '        return\n', '            interfaceId == type(IERC721).interfaceId ||\n', '            interfaceId == type(IERC721Metadata).interfaceId ||\n', '            super.supportsInterface(interfaceId);\n', '    }\n', '\n', '    function balanceOf(address owner)\n', '        public\n', '        view\n', '        virtual\n', '        override\n', '        returns (uint256)\n', '    {\n', '        require(\n', '            owner != address(0),\n', '            "ERC721: balance query for the zero address"\n', '        );\n', '        return _balances[owner];\n', '    }\n', '\n', '    function ownerOf(uint256 tokenId)\n', '        public\n', '        view\n', '        virtual\n', '        override\n', '        returns (address)\n', '    {\n', '        address owner = _owners[tokenId];\n', '        require(\n', '            owner != address(0),\n', '            "ERC721: owner query for nonexistent token"\n', '        );\n', '        return owner;\n', '    }\n', '\n', '    function tokenURI(uint256 tokenId)\n', '        public\n', '        view\n', '        virtual\n', '        returns (string memory)\n', '    {\n', '        require(\n', '            _exists(tokenId),\n', '            "ERC721Metadata: URI query for nonexistent token"\n', '        );\n', '\n', '        string memory baseURI = _baseURI();\n', '        return\n', '            bytes(baseURI).length > 0\n', '                ? string(abi.encodePacked(baseURI, tokenId))\n', '                : "";\n', '    }\n', '\n', '    /**\n', '     * @dev Base URI for computing {tokenURI}. Empty by default, can be overriden\n', '     * in child contracts.\n', '     */\n', '    function _baseURI() internal view virtual returns (string memory) {\n', '        return "";\n', '    }\n', '\n', '    function approve(address to, uint256 tokenId) public virtual override {\n', '        address owner = ERC721.ownerOf(tokenId);\n', '        require(to != owner, "ERC721: approval to current owner");\n', '\n', '        require(\n', '            msg.sender == owner || isApprovedForAll(owner, msg.sender),\n', '            "ERC721: approve caller is not owner nor approved for all"\n', '        );\n', '\n', '        _approve(to, tokenId);\n', '    }\n', '\n', '    function getApproved(uint256 tokenId)\n', '        public\n', '        view\n', '        virtual\n', '        override\n', '        returns (address)\n', '    {\n', '        require(\n', '            _exists(tokenId),\n', '            "ERC721: approved query for nonexistent token"\n', '        );\n', '\n', '        return _tokenApprovals[tokenId];\n', '    }\n', '\n', '    function setApprovalForAll(address operator, bool approved)\n', '        public\n', '        virtual\n', '        override\n', '    {\n', '        require(operator != msg.sender, "ERC721: approve to caller");\n', '\n', '        _operatorApprovals[msg.sender][operator] = approved;\n', '        emit ApprovalForAll(msg.sender, operator, approved);\n', '    }\n', '\n', '    function isApprovedForAll(address owner, address operator)\n', '        public\n', '        view\n', '        virtual\n', '        override\n', '        returns (bool)\n', '    {\n', '        return _operatorApprovals[owner][operator];\n', '    }\n', '\n', '    function transferFrom(\n', '        address from,\n', '        address to,\n', '        uint256 tokenId\n', '    ) public virtual override {\n', '        //solhint-disable-next-line max-line-length\n', '        require(\n', '            _isApprovedOrOwner(msg.sender, tokenId),\n', '            "ERC721: transfer caller is not owner nor approved"\n', '        );\n', '\n', '        _transfer(from, to, tokenId);\n', '    }\n', '\n', '    function safeTransferFrom(\n', '        address from,\n', '        address to,\n', '        uint256 tokenId\n', '    ) public virtual override {\n', '        safeTransferFrom(from, to, tokenId, "");\n', '    }\n', '\n', '    function safeTransferFrom(\n', '        address from,\n', '        address to,\n', '        uint256 tokenId,\n', '        bytes memory _data\n', '    ) public virtual override {\n', '        require(\n', '            _isApprovedOrOwner(msg.sender, tokenId),\n', '            "ERC721: transfer caller is not owner nor approved"\n', '        );\n', '        _safeTransfer(from, to, tokenId, _data);\n', '    }\n', '\n', '    function _safeTransfer(\n', '        address from,\n', '        address to,\n', '        uint256 tokenId,\n', '        bytes memory _data\n', '    ) internal virtual {\n', '        _transfer(from, to, tokenId);\n', '        require(\n', '            _checkOnERC721Received(from, to, tokenId, _data),\n', '            "ERC721: transfer to non ERC721Receiver implementer"\n', '        );\n', '    }\n', '\n', '    function _exists(uint256 tokenId) internal view virtual returns (bool) {\n', '        return _owners[tokenId] != address(0);\n', '    }\n', '\n', '    function _isApprovedOrOwner(address spender, uint256 tokenId)\n', '        internal\n', '        view\n', '        virtual\n', '        returns (bool)\n', '    {\n', '        require(\n', '            _exists(tokenId),\n', '            "ERC721: operator query for nonexistent token"\n', '        );\n', '        address owner = ERC721.ownerOf(tokenId);\n', '        return (spender == owner ||\n', '            getApproved(tokenId) == spender ||\n', '            isApprovedForAll(owner, spender));\n', '    }\n', '\n', '    function _safeMint(address to, uint256 tokenId) internal virtual {\n', '        _safeMint(to, tokenId, "");\n', '    }\n', '\n', '    function _safeMint(\n', '        address to,\n', '        uint256 tokenId,\n', '        bytes memory _data\n', '    ) internal virtual {\n', '        _mint(to, tokenId);\n', '        require(\n', '            _checkOnERC721Received(address(0), to, tokenId, _data),\n', '            "ERC721: transfer to non ERC721Receiver implementer"\n', '        );\n', '    }\n', '\n', '    function _mint(address to, uint256 tokenId) internal virtual {\n', '        require(to != address(0), "ERC721: mint to the zero address");\n', '        require(!_exists(tokenId), "ERC721: token already minted");\n', '\n', '        _balances[to] += 1;\n', '        _owners[tokenId] = to;\n', '\n', '        emit Transfer(address(0), to, tokenId);\n', '    }\n', '\n', '    function _burn(uint256 tokenId) internal virtual {\n', '        address owner = ERC721.ownerOf(tokenId);\n', '\n', '        // Clear approvals\n', '        _approve(address(0), tokenId);\n', '\n', '        _balances[owner] -= 1;\n', '        delete _owners[tokenId];\n', '\n', '        emit Transfer(owner, address(0), tokenId);\n', '    }\n', '\n', '    function _transfer(\n', '        address from,\n', '        address to,\n', '        uint256 tokenId\n', '    ) internal virtual {\n', '        require(\n', '            ERC721.ownerOf(tokenId) == from,\n', '            "ERC721: transfer of token that is not own"\n', '        );\n', '        require(to != address(0), "ERC721: transfer to the zero address");\n', '\n', '        // Clear approvals from the previous owner\n', '        _approve(address(0), tokenId);\n', '\n', '        _balances[from] -= 1;\n', '        _balances[to] += 1;\n', '        _owners[tokenId] = to;\n', '\n', '        emit Transfer(from, to, tokenId);\n', '    }\n', '\n', '    function _approve(address to, uint256 tokenId) internal virtual {\n', '        _tokenApprovals[tokenId] = to;\n', '        emit Approval(ERC721.ownerOf(tokenId), to, tokenId);\n', '    }\n', '\n', '    function _checkOnERC721Received(\n', '        address from,\n', '        address to,\n', '        uint256 tokenId,\n', '        bytes memory _data\n', '    ) private returns (bool) {\n', '        if (isContract(to)) {\n', '            try\n', '                IERC721Receiver(to).onERC721Received(\n', '                    msg.sender,\n', '                    from,\n', '                    tokenId,\n', '                    _data\n', '                )\n', '            returns (bytes4 retval) {\n', '                return retval == IERC721Receiver(to).onERC721Received.selector;\n', '            } catch (bytes memory reason) {\n', '                if (reason.length == 0) {\n', '                    revert(\n', '                        "ERC721: transfer to non ERC721Receiver implementer"\n', '                    );\n', '                } else {\n', '                    // solhint-disable-next-line no-inline-assembly\n', '                    assembly {\n', '                        revert(add(32, reason), mload(reason))\n', '                    }\n', '                }\n', '            }\n', '        } else {\n', '            return true;\n', '        }\n', '    }\n', '\n', '    // https://github.com/OpenZeppelin/openzeppelin-contracts/blob/7f6a1666fac8ecff5dd467d0938069bc221ea9e0/contracts/utils/Address.sol\n', '    function isContract(address account) internal view returns (bool) {\n', '        uint256 size;\n', '        // solhint-disable-next-line no-inline-assembly\n', '        assembly {\n', '            size := extcodesize(account)\n', '        }\n', '        return size > 0;\n', '    }\n', '}\n', '\n', '\n', '// File contracts/Editions.sol\n', '\n', '\n', '/**\n', ' * @title Editions\n', ' * @author MirrorXYZ\n', ' */\n', 'contract Editions is ERC721 {\n', '    // ============ Constants ============\n', '\n', '    string public constant name = "Mirror Editions V2";\n', '    string public constant symbol = "EDITIONS_V2";\n', '\n', '    uint256 internal constant REENTRANCY_NOT_ENTERED = 1;\n', '    uint256 internal constant REENTRANCY_ENTERED = 2;\n', '\n', '    // ============ Structs ============\n', '\n', '    struct Edition {\n', '        // The maximum number of tokens that can be sold.\n', '        uint256 quantity;\n', '        // The price at which each token will be sold, in ETH.\n', '        uint256 price;\n', '        // The account that will receive sales revenue.\n', '        address payable fundingRecipient;\n', '        // The number of tokens sold so far.\n', '        uint256 numSold;\n', '    }\n', '\n', '    // A subset of Edition, for efficient production of multiple editions.\n', '    struct EditionTier {\n', '        // The maximum number of tokens that can be sold.\n', '        uint256 quantity;\n', '        // The price at which each token will be sold, in ETH.\n', '        uint256 price;\n', '        bytes32 contentHash;\n', '    }\n', '\n', '    mapping(address => uint256) public fundingBalance;\n', '\n', '    // ============ Immutable Storage ============\n', '\n', '    // Fee updates take 2 days to take place, giving creators time to withdraw.\n', '    uint256 public immutable feeUpdateTimelock;\n', '\n', '    // ============ Mutable Storage ============\n', '\n', '    string internal baseURI;\n', '    // Mapping of edition id to descriptive data.\n', '    mapping(uint256 => Edition) public editions;\n', '    // Mapping of token id to edition id.\n', '    mapping(uint256 => uint256) public tokenToEdition;\n', '    // The amount of funds that have already been withdrawn for a given edition.\n', '    mapping(uint256 => uint256) public withdrawnForEdition;\n', '    // `nextTokenId` increments with each token purchased, globally across all editions.\n', '    uint256 private nextTokenId;\n', "    // Editions start at 1, in order that unsold tokens don't map to the first edition.\n", '    uint256 private nextEditionId = 1;\n', '    // Withdrawals include a fee, specified as a percentage.\n', '    uint16 public feePercent;\n', '    // The address that holds fees.\n', '    address payable public treasury;\n', '    uint256 public feesAccrued;\n', '    // Timelock information.\n', '    uint256 public nextFeeUpdateTime;\n', '    uint16 public nextFeePercent;\n', '    // Reentrancy\n', '    uint256 internal reentrancyStatus;\n', '\n', '    address public owner;\n', '    address public nextOwner;\n', '\n', '    // ============ Events ============\n', '\n', '    event EditionCreated(\n', '        uint256 quantity,\n', '        uint256 price,\n', '        address fundingRecipient,\n', '        uint256 indexed editionId,\n', '        bytes32 contentHash\n', '    );\n', '\n', '    event EditionPurchased(\n', '        uint256 indexed editionId,\n', '        uint256 indexed tokenId,\n', '        // `numSold` at time of purchase represents the "serial number" of the NFT.\n', '        uint256 numSold,\n', '        uint256 amountPaid,\n', '        // The account that paid for and received the NFT.\n', '        address indexed buyer\n', '    );\n', '\n', '    event FundsWithdrawn(\n', '        address fundingRecipient,\n', '        uint256 amountWithdrawn,\n', '        uint256 feeAmount\n', '    );\n', '\n', '    event OwnershipTransferred(\n', '        address indexed previousOwner,\n', '        address indexed newOwner\n', '    );\n', '\n', '    event FeesWithdrawn(uint256 feesAccrued, address sender);\n', '\n', '    event FeeUpdateQueued(uint256 newFee, address sender);\n', '\n', '    event FeeUpdated(uint256 feePercent, address sender);\n', '\n', '    // ============ Modifiers ============\n', '\n', '    modifier nonReentrant() {\n', '        // On the first call to nonReentrant, _notEntered will be true\n', '        require(reentrancyStatus != REENTRANCY_ENTERED, "Reentrant call");\n', '\n', '        // Any calls to nonReentrant after this point will fail\n', '        reentrancyStatus = REENTRANCY_ENTERED;\n', '\n', '        _;\n', '\n', '        // By storing the original value once again, a refund is triggered (see\n', '        // https://eips.ethereum.org/EIPS/eip-2200)\n', '        reentrancyStatus = REENTRANCY_NOT_ENTERED;\n', '    }\n', '\n', '    modifier onlyOwner() {\n', '        require(isOwner(), "caller is not the owner.");\n', '        _;\n', '    }\n', '\n', '    modifier onlyNextOwner() {\n', '        require(isNextOwner(), "current owner must set caller as next owner.");\n', '        _;\n', '    }\n', '\n', '    // ============ Constructor ============\n', '\n', '    constructor(\n', '        string memory baseURI_,\n', '        address payable treasury_,\n', '        uint16 initialFee,\n', '        uint256 feeUpdateTimelock_,\n', '        address owner_\n', '    ) {\n', '        baseURI = baseURI_;\n', '        treasury = treasury_;\n', '        feePercent = initialFee;\n', '        feeUpdateTimelock = feeUpdateTimelock_;\n', '        owner = owner_;\n', '    }\n', '\n', '    // ============ Edition Methods ============\n', '\n', '    function createEditionTiers(\n', '        EditionTier[] memory tiers,\n', '        address payable fundingRecipient\n', '    ) external nonReentrant {\n', '        // Execute a loop that creates editions.\n', '        for (uint8 i = 0; i < tiers.length; i++) {\n', '            uint256 quantity = tiers[i].quantity;\n', '            uint256 price = tiers[i].price;\n', '\n', '            editions[nextEditionId] = Edition({\n', '                quantity: quantity,\n', '                price: price,\n', '                fundingRecipient: fundingRecipient,\n', '                numSold: 0\n', '            });\n', '\n', '            emit EditionCreated(\n', '                quantity,\n', '                price,\n', '                fundingRecipient,\n', '                nextEditionId,\n', '                tiers[i].contentHash\n', '            );\n', '\n', '            nextEditionId++;\n', '        }\n', '    }\n', '\n', '    function createEdition(\n', '        // The number of tokens that can be minted and sold.\n', '        uint256 quantity,\n', '        // The price to purchase a token.\n', '        uint256 price,\n', '        // The account that should receive the revenue.\n', '        address payable fundingRecipient,\n', '        // Content hash is emitted in the event, for UI convenience.\n', '        bytes32 contentHash\n', '    ) external nonReentrant {\n', '        editions[nextEditionId] = Edition({\n', '            quantity: quantity,\n', '            price: price,\n', '            fundingRecipient: fundingRecipient,\n', '            numSold: 0\n', '        });\n', '\n', '        emit EditionCreated(\n', '            quantity,\n', '            price,\n', '            fundingRecipient,\n', '            nextEditionId,\n', '            contentHash\n', '        );\n', '\n', '        nextEditionId++;\n', '    }\n', '\n', '    function buyEdition(uint256 editionId) external payable nonReentrant {\n', '        // Check that the edition exists. Note: this is redundant\n', '        // with the next check, but it is useful for clearer error messaging.\n', '        require(editions[editionId].quantity > 0, "Edition does not exist");\n', '        // Check that there are still tokens available to purchase.\n', '        require(\n', '            editions[editionId].numSold < editions[editionId].quantity,\n', '            "This edition is already sold out."\n', '        );\n', '        // Check that the sender is paying the correct amount.\n', '        require(\n', '            msg.value >= editions[editionId].price,\n', '            "Must send enough to purchase the edition."\n', '        );\n', '        // Increment the number of tokens sold for this edition.\n', '        editions[editionId].numSold++;\n', '        fundingBalance[editions[editionId].fundingRecipient] += msg.value;\n', '        // Mint a new token for the sender, using the `nextTokenId`.\n', '        _mint(msg.sender, nextTokenId);\n', '        // Store the mapping of token id to the edition being purchased.\n', '        tokenToEdition[nextTokenId] = editionId;\n', '\n', '        emit EditionPurchased(\n', '            editionId,\n', '            nextTokenId,\n', '            editions[editionId].numSold,\n', '            msg.value,\n', '            msg.sender\n', '        );\n', '\n', '        nextTokenId++;\n', '    }\n', '\n', '    // ============ Operational Methods ============\n', '\n', '    function withdrawFunds(address payable fundingRecipient)\n', '        external\n', '        nonReentrant\n', '    {\n', '        uint256 remaining = fundingBalance[fundingRecipient];\n', '        fundingBalance[fundingRecipient] = 0;\n', '\n', '        if (feePercent > 0) {\n', '            // Send the amount that was remaining for the edition, to the funding recipient.\n', '            uint256 fee = computeFee(remaining);\n', '            // Allocate fee to the treasury.\n', '            feesAccrued += fee;\n', '            // Send the remainder to the funding recipient.\n', '            _sendFunds(fundingRecipient, remaining - fee);\n', '            emit FundsWithdrawn(fundingRecipient, remaining - fee, fee);\n', '        } else {\n', '            _sendFunds(fundingRecipient, remaining);\n', '            emit FundsWithdrawn(fundingRecipient, remaining, 0);\n', '        }\n', '    }\n', '\n', '    function computeFee(uint256 _amount) public view returns (uint256) {\n', '        return (_amount * feePercent) / 100;\n', '    }\n', '\n', '    // ============ Admin Methods ============\n', '\n', '    function withdrawFees() public {\n', '        _sendFunds(treasury, feesAccrued);\n', '        emit FeesWithdrawn(feesAccrued, msg.sender);\n', '        feesAccrued = 0;\n', '    }\n', '\n', '    function updateTreasury(address payable newTreasury) public {\n', '        require(msg.sender == treasury, "Only available to current treasury");\n', '        treasury = newTreasury;\n', '    }\n', '\n', '    function queueFeeUpdate(uint16 newFee) public {\n', '        require(msg.sender == treasury, "Only available to treasury");\n', '        nextFeeUpdateTime = block.timestamp + feeUpdateTimelock;\n', '        nextFeePercent = newFee;\n', '        emit FeeUpdateQueued(newFee, msg.sender);\n', '    }\n', '\n', '    function executeFeeUpdate() public {\n', '        require(msg.sender == treasury, "Only available to current treasury");\n', '        require(\n', '            block.timestamp >= nextFeeUpdateTime,\n', '            "Timelock hasn\'t elapsed"\n', '        );\n', '        feePercent = nextFeePercent;\n', '        nextFeePercent = 0;\n', '        nextFeeUpdateTime = 0;\n', '        emit FeeUpdated(feePercent, msg.sender);\n', '    }\n', '\n', '    function changeBaseURI(string memory baseURI_) public onlyOwner {\n', '        baseURI = baseURI_;\n', '    }\n', '\n', '    function isOwner() public view returns (bool) {\n', '        return msg.sender == owner;\n', '    }\n', '\n', '    function isNextOwner() public view returns (bool) {\n', '        return msg.sender == nextOwner;\n', '    }\n', '\n', '    function transferOwnership(address nextOwner_) external onlyOwner {\n', '        require(nextOwner_ != address(0), "Next owner is the zero address.");\n', '\n', '        nextOwner = nextOwner_;\n', '    }\n', '\n', '    function cancelOwnershipTransfer() external onlyOwner {\n', '        delete nextOwner;\n', '    }\n', '\n', '    function acceptOwnership() external onlyNextOwner {\n', '        delete nextOwner;\n', '\n', '        emit OwnershipTransferred(owner, msg.sender);\n', '\n', '        owner = msg.sender;\n', '    }\n', '\n', '    function renounceOwnership() external onlyOwner {\n', '        emit OwnershipTransferred(owner, address(0));\n', '        owner = address(0);\n', '    }\n', '\n', '    // ============ NFT Methods ============\n', '\n', '    // Returns e.g. https://mirror-api.com/editions/[editionId]/[tokenId]\n', '    function tokenURI(uint256 tokenId)\n', '        public\n', '        view\n', '        override\n', '        returns (string memory)\n', '    {\n', "        // If the token does not map to an edition, it'll be 0.\n", '        require(tokenToEdition[tokenId] > 0, "Token has not been sold yet");\n', '        // Concatenate the components, baseURI, editionId and tokenId, to create URI.\n', '        return\n', '            string(\n', '                abi.encodePacked(\n', '                    baseURI,\n', '                    _toString(tokenToEdition[tokenId]),\n', '                    "/",\n', '                    _toString(tokenId)\n', '                )\n', '            );\n', '    }\n', '\n', '    // Returns e.g. https://mirror-api.com/editions/metadata\n', '    function contractURI() public view returns (string memory) {\n', '        // Concatenate the components, baseURI, editionId and tokenId, to create URI.\n', '        return string(abi.encodePacked(baseURI, "metadata"));\n', '    }\n', '\n', '    function getRoyaltyRecipient(uint256 tokenId)\n', '        public\n', '        view\n', '        returns (address)\n', '    {\n', '        require(tokenToEdition[tokenId] > 0, "Token has not been minted yet");\n', '        return editions[tokenToEdition[tokenId]].fundingRecipient;\n', '    }\n', '\n', '    function setRoyaltyRecipient(\n', '        uint256 editionId,\n', '        address payable newFundingRecipient\n', '    ) public {\n', '        require(\n', '            editions[editionId].fundingRecipient == msg.sender,\n', '            "Only current fundingRecipient can modify its value"\n', '        );\n', '\n', '        editions[editionId].fundingRecipient = newFundingRecipient;\n', '    }\n', '\n', '    // ============ Private Methods ============\n', '\n', '    function _sendFunds(address payable recipient, uint256 amount) private {\n', '        require(\n', '            address(this).balance >= amount,\n', '            "Insufficient balance for send"\n', '        );\n', '\n', '        (bool success, ) = recipient.call{value: amount}("");\n', '        require(success, "Unable to send value: recipient may have reverted");\n', '    }\n', '\n', '    // From https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Strings.sol\n', '    function _toString(uint256 value) internal pure returns (string memory) {\n', "        // Inspired by OraclizeAPI's implementation - MIT licence\n", '        // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol\n', '\n', '        if (value == 0) {\n', '            return "0";\n', '        }\n', '        uint256 temp = value;\n', '        uint256 digits;\n', '        while (temp != 0) {\n', '            digits++;\n', '            temp /= 10;\n', '        }\n', '        bytes memory buffer = new bytes(digits);\n', '        while (value != 0) {\n', '            digits -= 1;\n', '            buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));\n', '            value /= 10;\n', '        }\n', '        return string(buffer);\n', '    }\n', '}']