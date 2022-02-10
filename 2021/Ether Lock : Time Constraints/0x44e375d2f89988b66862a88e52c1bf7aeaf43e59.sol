['// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity ^0.7.6;\n', '\n', 'import "./ERC721.sol";\n', '\n', 'contract RareApes is ERC721 {\n', '    using SafeMath for uint256;\n', '    using Strings for uint256;\n', '\n', '    uint256 public constant NFT_PRICE = 10**17;\n', '\n', '    uint256 public constant MAX_NFT_SUPPLY = 5000;\n', '\n', '    uint256 public immutable SALE_START_TIMESTAMP;\n', '\n', '    uint256 public immutable REVEAL_TIMESTAMP;\n', '\n', '    uint256 public startingIndexBlock;\n', '\n', '    uint256 public startingIndex;\n', '\n', '    address payable private immutable _owner;\n', '\n', '    address payable private immutable _partner;\n', '\n', '    constructor (\n', '        string memory name, \n', '        string memory symbol, \n', '        string memory baseURI,\n', '        uint256 saleStartTimestamp,\n', '        address payable partner\n', '        ) public ERC721 (name, symbol) {\n', '            SALE_START_TIMESTAMP = saleStartTimestamp;\n', '            REVEAL_TIMESTAMP = saleStartTimestamp + (86400 * 14);\n', '            _owner = msg.sender;\n', '            _partner = partner;\n', '            _setBaseURI(baseURI);\n', '    }\n', '\n', '    /**\n', '     * @dev See {IERC721Metadata-tokenURI}.\n', '     */\n', '    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {\n', '        require(startingIndex > 0, "Tokens have not been revealed yet");\n', '        require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");\n', '\n', '        uint256 realTokenId = tokenId.add(startingIndex) % MAX_NFT_SUPPLY;\n', '        string memory base = baseURI();\n', '\n', '        return string(abi.encodePacked(base, realTokenId.toString(), ".json"));\n', '    }\n', '\n', '    /**\n', '    * @dev Mints NFT\n', '    */\n', '    function mintNFT(uint256 numberOfNfts) public payable {\n', '        require(block.timestamp >= SALE_START_TIMESTAMP, "Sale has not started");\n', '        require(totalSupply() < MAX_NFT_SUPPLY, "Sale has already ended");\n', '        require(numberOfNfts > 0, "numberOfNfts cannot be 0");\n', '        require(numberOfNfts <= 20, "You may not buy more than 20 NFTs at once");\n', '        require(totalSupply().add(numberOfNfts) <= MAX_NFT_SUPPLY, "Exceeds MAX_NFT_SUPPLY");\n', '        require(NFT_PRICE.mul(numberOfNfts) == msg.value, "Ether value sent is not correct");\n', '\n', '        for (uint i = 0; i < numberOfNfts; i++) {\n', '            uint mintIndex = totalSupply();\n', '            _safeMint(msg.sender, mintIndex);\n', '        }\n', '\n', '        /**\n', '        * Source of randomness. Theoretical miner withhold manipulation possible but should be sufficient in a pragmatic sense\n', '        */\n', '        if (startingIndexBlock == 0 && (totalSupply() == MAX_NFT_SUPPLY || block.timestamp >= REVEAL_TIMESTAMP)) {\n', '            startingIndexBlock = block.number;\n', '        }\n', '    }\n', '\n', '    /**\n', '     * @dev Finalize starting index\n', '     */\n', '    function finalizeStartingIndex() public {\n', '        require(startingIndex == 0, "Starting index is already set");\n', '        require(startingIndexBlock != 0, "Starting index block must be set");\n', '        \n', '        startingIndex = uint(blockhash(startingIndexBlock)) % MAX_NFT_SUPPLY;\n', '        // Just a sanity case in the worst case if this function is called late (EVM only stores last 256 block hashes)\n', '        if (block.number.sub(startingIndexBlock) > 255) {\n', '            startingIndex = uint(blockhash(block.number-1)) % MAX_NFT_SUPPLY;\n', '        }\n', '        // Prevent default sequence\n', '        if (startingIndex == 0) {\n', '            startingIndex = startingIndex.add(1);\n', '        }\n', '    }\n', '\n', '    /**\n', '     * @dev Withdraw ether from this contract (Callable by owner and partner)\n', '    */\n', '    function withdraw() public {\n', '        require(_msgSender() == _owner || _msgSender() == _partner, "Caller is neither the owner nor the withdrawal address");\n', '        uint balance = address(this).balance;\n', '        uint ownerAmount = balance.div(5);\n', '        uint partnerAmount = balance - ownerAmount;\n', '        _owner.transfer(ownerAmount);\n', '        _partner.transfer(partnerAmount);\n', '    }\n', '}']