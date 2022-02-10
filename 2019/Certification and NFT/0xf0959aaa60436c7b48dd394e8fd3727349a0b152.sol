['pragma solidity ^0.4.11;\n', '\n', 'contract ERC20 {\n', '    function transfer(address to, uint tokens) public returns (bool success);\n', '}\n', '\n', 'contract owned {\n', '    address public owner;\n', '\n', '    constructor() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address newOwner) onlyOwner public {\n', '        owner = newOwner;\n', '    }\n', '}\n', '\n', '\n', 'library SafeMath {\n', '    function mul(uint a, uint b) internal pure returns (uint) {\n', '        uint c = a * b;\n', '        assert(a == 0 || c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function div(uint a, uint b) internal pure returns (uint) {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        uint c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '        return c;\n', '    }\n', '\n', '    function sub(uint a, uint b) internal pure returns (uint) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function add(uint a, uint b) internal pure returns (uint) {\n', '        uint c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '\n', '    function max64(uint64 a, uint64 b) internal pure returns (uint64) {\n', '        return a >= b ? a : b;\n', '    }\n', '\n', '    function min64(uint64 a, uint64 b) internal pure returns (uint64) {\n', '        return a < b ? a : b;\n', '    }\n', '\n', '    function max256(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return a >= b ? a : b;\n', '    }\n', '\n', '    function min256(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return a < b ? a : b;\n', '    }\n', '}\n', '\n', '\n', 'contract RocketsICO is owned {\n', '    using SafeMath for uint;\n', '    bool public ICOOpening = true;\n', '    uint256 public USD;\n', '    uint256 public ICORate = 1;\n', '    uint256 public ICOBonus = 0;\n', '    address public ROK = 0xca2660F10ec310DF91f3597574634A7E51d717FC;\n', '\n', '    function updateUSD(uint256 usd) onlyOwner public {\n', '        USD = usd;\n', '    }\n', '\n', '    function updateRate(uint256 rate, uint256 bonus) onlyOwner public {\n', '        ICORate = rate;\n', '        ICOBonus = bonus;\n', '    }\n', '\n', '    function updateOpen(bool opening) onlyOwner public{\n', '        ICOOpening = opening;\n', '    }\n', '\n', '    constructor() public {\n', '    }\n', '\n', '    function() public payable {\n', '        buy();\n', '    }\n', '\n', '    function getAmountToBuy(uint256 ethAmount) public view returns (uint256){\n', '        uint256 tokensToBuy;\n', '        tokensToBuy = ethAmount.mul(USD).mul(ICORate);\n', '        if(ICOBonus > 0){\n', '            uint256 bonusAmount;\n', '            bonusAmount = tokensToBuy.div(100).mul(ICOBonus);\n', '            tokensToBuy = tokensToBuy.add(bonusAmount);\n', '        }\n', '        return tokensToBuy;\n', '    }\n', '\n', '    function buy() public payable {\n', '        require(ICOOpening == true);\n', '        uint256 tokensToBuy;\n', '        uint256 ethAmount = msg.value;\n', '        tokensToBuy = ethAmount.mul(USD).mul(ICORate);\n', '        if(ICOBonus > 0){\n', '            uint256 bonusAmount;\n', '            bonusAmount = tokensToBuy.div(100).mul(ICOBonus);\n', '            tokensToBuy = tokensToBuy.add(bonusAmount);\n', '        }\n', '        ERC20(ROK).transfer(msg.sender, tokensToBuy);\n', '    }\n', '\n', '    function withdrawROK(uint256 amount, address sendTo) onlyOwner public {\n', '        ERC20(ROK).transfer(sendTo, amount);\n', '    }\n', '\n', '    function withdrawEther(uint256 amount, address sendTo) onlyOwner public {\n', '        address(sendTo).transfer(amount);\n', '    }\n', '\n', '    function withdrawToken(ERC20 token, uint256 amount, address sendTo) onlyOwner public {\n', '        require(token.transfer(sendTo, amount));\n', '    }\n', '}']