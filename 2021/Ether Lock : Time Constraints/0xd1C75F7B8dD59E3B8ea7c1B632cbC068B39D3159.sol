['// SPDX-License-Identifier: UNLICENSED\n', 'pragma solidity ^0.6.7;\n', '\n', 'library SafeMath {\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '        return c;\n', '    }\n', '    \n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return sub(a, b, "SafeMath: subtraction overflow");\n', '    }\n', '    \n', '    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b <= a, errorMessage);\n', '        uint256 c = a - b;\n', '        return c;\n', '    }\n', '    \n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '        return c;\n', '    }\n', '    \n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return div(a, b, "SafeMath: division by zero");\n', '    }\n', '    \n', '    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        // Solidity only automatically asserts when dividing by 0\n', '        require(b > 0, errorMessage);\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '        return c;\n', '    }\n', '    \n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return mod(a, b, "SafeMath: modulo by zero");\n', '    }\n', '    \n', '    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b != 0, errorMessage);\n', '        return a % b;\n', '    }\n', '}\n', '\n', 'interface IERC721 {\n', '    function safeTransferFrom(address from, address to, uint256 tokenId) external;\n', '}\n', '\n', 'contract EnglishAuctionPropy {\n', '    using SafeMath for uint256;\n', '\n', '    // System settings\n', '    address public deployer;\n', '    uint256 public id;\n', '    address public token;\n', '    bool public ended = false;\n', '    mapping (address => bool) private blacklistedBidders;\n', '    \n', '    // Current winning bid\n', '    uint256 public lastBid;\n', '    address payable public winning;\n', '    \n', '    uint256 public length;\n', '    uint256 public startTime;\n', '    uint256 public endTime;\n', '    \n', '    address payable public haus;\n', '    address payable public seller;\n', '    \n', '    event Bid(address who, uint256 amount);\n', '    event Won(address who, uint256 amount);\n', '    \n', '    constructor(uint256 _id, uint256 _startTime) public {\n', '        token = address(0x2dbC375B35c5A2B6E36A386c8006168b686b70D3);\n', '        id = _id;\n', '        startTime = _startTime;\n', '        length = 24 hours;\n', '        endTime = startTime + length;\n', '        lastBid = 7.5 ether;\n', '        seller = payable(address(0x36228C2A182101e4Cb8a6519C0689b0d75775587));\n', '        haus = payable(address(0x15884D7a5567725E0306A90262ee120aD8452d58));\n', '        deployer = msg.sender;\n', '    }\n', '    \n', '    function bid() public payable {\n', '        require(blacklistedBidders[msg.sender] == false, "blacklisted address");\n', '        require(msg.sender == tx.origin, "no contracts");\n', '        require(block.timestamp >= startTime, "Auction not started");\n', '        require(block.timestamp < endTime, "Auction ended");\n', '        require(msg.value >= lastBid.mul(102).div(100), "Bid too small"); // 2% increase\n', '        \n', '        // Give back the last bidders money\n', '        if (winning != address(0)) {\n', '            winning.transfer(lastBid);\n', '        }\n', '        \n', '        if (endTime - now < 15 minutes) {\n', '            endTime = now + 15 minutes;\n', '        }\n', '        \n', '        lastBid = msg.value;\n', '        winning = msg.sender;\n', '        emit Bid(msg.sender, msg.value);\n', '    }\n', '    \n', '    function end() public {\n', '        require(!ended, "end already called");\n', '        require(winning != address(0), "no bids");\n', '        require(!live(), "Auction live");\n', '        // transfer erc721 to winner\n', '        IERC721(token).safeTransferFrom(address(seller), winning, id); // Will transfer ERC721 from current owner to new owner\n', '        uint256 balance = address(this).balance;\n', '        uint256 hausFee = balance.div(20);\n', '        haus.transfer(hausFee);\n', '        seller.transfer(address(this).balance);\n', '        ended = true;\n', '        emit Won(winning, lastBid);\n', '    }\n', '\n', '    function addToBlacklist(address _toBlacklist) public {\n', '        require(msg.sender == deployer, "must be deployer");\n', '        blacklistedBidders[_toBlacklist] = true;\n', '    }\n', '\n', '    function removeFromBlacklist(address _toBlacklist) public {\n', '        require(msg.sender == deployer, "must be deployer");\n', '        blacklistedBidders[_toBlacklist] = false;\n', '    }\n', '    \n', '    function live() public view returns(bool) {\n', '        return block.timestamp < endTime;\n', '    }\n', '}\n', '\n', '{\n', '  "optimizer": {\n', '    "enabled": false,\n', '    "runs": 200\n', '  },\n', '  "outputSelection": {\n', '    "*": {\n', '      "*": [\n', '        "evm.bytecode",\n', '        "evm.deployedBytecode",\n', '        "abi"\n', '      ]\n', '    }\n', '  },\n', '  "libraries": {}\n', '}']