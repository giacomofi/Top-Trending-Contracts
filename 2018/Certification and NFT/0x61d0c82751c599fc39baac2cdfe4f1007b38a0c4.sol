['pragma solidity ^0.4.24;\n', '\n', 'contract ETHCOOLAdvertisements {\n', '\n', '    using SafeMath for uint;\n', '\n', '    struct Advertisement {\n', '        address user;\n', '        string text;\n', '        string link;\n', '        uint expiry;\n', '    }\n', '\n', '    address public owner;\n', '    uint public display_rate;\n', '    uint public owner_share;\n', '\n', '    ETHCOOLMain main_contract;\n', '    Advertisement[] public advertisements;\n', '    \n', '    constructor() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    function publicGetStatus() view public returns (uint) {\n', '        return (advertisements.length);\n', '    }\n', '\n', '    function publicGetAdvertisement(uint index) view public returns (address, string, string, uint) {\n', '        return (advertisements[index].user, advertisements[index].text, advertisements[index].link, advertisements[index].expiry);\n', '    }\n', '\n', '    function ownerConfig(address main, uint rate, uint share) public {\n', '        if (msg.sender == owner) {\n', '            display_rate = rate;\n', '            owner_share = share;\n', '            main_contract = ETHCOOLMain(main);\n', '        }\n', '    }\n', '\n', '    function userCreate(string text, string link) public payable {\n', '        if (msg.value > 0) {\n', '            uint expiry = now.add(msg.value.div(display_rate));\n', '            Advertisement memory ad = Advertisement(msg.sender, text, link, expiry);\n', '            advertisements.push(ad);\n', '        }\n', '    }\n', '\n', '    function userTransfer() public {\n', '        if (address(this).balance > 0) {\n', '            main_contract.contractBoost.value(address(this).balance)(owner_share);\n', '        }\n', '    }\n', '}\n', '\n', 'contract ETHCOOLMain {\n', '    function contractBoost(uint share) public payable {}\n', '}\n', '\n', 'library SafeMath {\n', '\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return a / b;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '        c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}']
['pragma solidity ^0.4.24;\n', '\n', 'contract ETHCOOLAdvertisements {\n', '\n', '    using SafeMath for uint;\n', '\n', '    struct Advertisement {\n', '        address user;\n', '        string text;\n', '        string link;\n', '        uint expiry;\n', '    }\n', '\n', '    address public owner;\n', '    uint public display_rate;\n', '    uint public owner_share;\n', '\n', '    ETHCOOLMain main_contract;\n', '    Advertisement[] public advertisements;\n', '    \n', '    constructor() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    function publicGetStatus() view public returns (uint) {\n', '        return (advertisements.length);\n', '    }\n', '\n', '    function publicGetAdvertisement(uint index) view public returns (address, string, string, uint) {\n', '        return (advertisements[index].user, advertisements[index].text, advertisements[index].link, advertisements[index].expiry);\n', '    }\n', '\n', '    function ownerConfig(address main, uint rate, uint share) public {\n', '        if (msg.sender == owner) {\n', '            display_rate = rate;\n', '            owner_share = share;\n', '            main_contract = ETHCOOLMain(main);\n', '        }\n', '    }\n', '\n', '    function userCreate(string text, string link) public payable {\n', '        if (msg.value > 0) {\n', '            uint expiry = now.add(msg.value.div(display_rate));\n', '            Advertisement memory ad = Advertisement(msg.sender, text, link, expiry);\n', '            advertisements.push(ad);\n', '        }\n', '    }\n', '\n', '    function userTransfer() public {\n', '        if (address(this).balance > 0) {\n', '            main_contract.contractBoost.value(address(this).balance)(owner_share);\n', '        }\n', '    }\n', '}\n', '\n', 'contract ETHCOOLMain {\n', '    function contractBoost(uint share) public payable {}\n', '}\n', '\n', 'library SafeMath {\n', '\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return a / b;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '        c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}']