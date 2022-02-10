['pragma solidity ^0.4.24;\n', '\n', '/*\n', '\n', '    Copyright 2018, Angelo A. M. & Vicent Nos & Mireia Puig\n', '\n', '    This program is free software: you can redistribute it and/or modify\n', '    it under the terms of the GNU General Public License as published by\n', '    the Free Software Foundation, either version 3 of the License, or\n', '    (at your option) any later version.\n', '\n', '    This program is distributed in the hope that it will be useful,\n', '    but WITHOUT ANY WARRANTY; without even the implied warranty of\n', '    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the\n', '    GNU General Public License for more details.\n', '\n', '    You should have received a copy of the GNU General Public License\n', '    along with this program.  If not, see <http://www.gnu.org/licenses/>.\n', '\n', '*/\n', '\n', '\n', '\n', 'library SafeMath {\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        uint256 c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        uint256 c = a / b;\n', '        // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '        return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', '\n', '\n', 'contract Ownable {\n', '\n', '    address public owner;\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    constructor() internal {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '        require(newOwner != address(0));\n', '        emit OwnershipTransferred(owner, newOwner);\n', '        owner = newOwner;\n', '    }\n', '}\n', '\n', '\n', '\n', '//////////////////////////////////////////////////////////////\n', '//                                                          //\n', '//                ESSENTIA Public Engagement                //\n', '//                   https://essentia.one                   //\n', '//                                                          //\n', '//////////////////////////////////////////////////////////////\n', '\n', '\n', '\n', 'contract ESSENTIA_PE is Ownable {\n', '\n', '    // Contract variables and constants\n', '    using SafeMath for uint256;\n', '\n', '    uint256 public tokenPrice=0;\n', '    address public addrFWD;\n', '    address public token;\n', '    uint256 public decimals=18;\n', '    string public name="ESSENTIA Public Engagement";\n', '\n', '    mapping (address => uint256) public sold;\n', '\n', '    uint256 public pubEnd=0;\n', '    // constant to simplify conversion of token amounts into integer form\n', '    uint256 public tokenUnit = uint256(10)**decimals;\n', '\n', '\n', '\n', '    // destAddr is the address to which the contributions are forwarded\n', '    // mastTokCon is the address of the main token contract corresponding to the erc20 to be sold\n', '    // NOTE the contract will sell only its token balance on the erc20 specified in mastTokCon\n', '\n', '\n', '    constructor\n', '        (\n', '        address destAddr,\n', '        address mastTokCon\n', '        ) public {\n', '        addrFWD = destAddr;\n', '        token = mastTokCon;\n', '    }\n', '\n', '\n', '\n', '    function () public payable {\n', '        buy();   // Allow to buy tokens sending ether directly to the contract\n', '    }\n', '\n', '\n', '\n', '    function setPrice(uint256 _value) public onlyOwner{\n', '      tokenPrice=_value;   // Set the price token default 0\n', '\n', '    }\n', '\n', '    function setaddrFWD(address _value) public onlyOwner{\n', '      addrFWD=_value;   // Set the forward address default destAddr\n', '\n', '    }\n', '\n', '    function setPubEnd(uint256 _value) public onlyOwner{\n', '      pubEnd=_value;   // Set the END of engagement unixtime default 0\n', '\n', '    }\n', '\n', '\n', '\n', '    function buy()  public payable {\n', '        require(block.timestamp<pubEnd);\n', '        require(msg.value>0);\n', '        uint256 tokenAmount = (msg.value * tokenUnit) / tokenPrice;   // Calculate the amount of tokens\n', '\n', '        transferBuy(msg.sender, tokenAmount);\n', '        addrFWD.transfer(msg.value);\n', '    }\n', '\n', '\n', '\n', '    function withdrawPUB() public returns(bool){\n', '        require(block.timestamp>pubEnd);   // Finalize and transfer\n', '        require(sold[msg.sender]>0);\n', '\n', '\n', '        bool result=token.call(bytes4(keccak256("transfer(address,uint256)")), msg.sender, sold[msg.sender]);\n', '        delete sold[msg.sender];\n', '        return result;\n', '    }\n', '\n', '\n', '\n', '    function transferBuy(address _to, uint256 _value) internal returns (bool) {\n', '        require(_to != address(0));\n', '\n', '        sold[_to]=sold[_to].add(_value);   // Account for multiple txs from the same address\n', '\n', '        return true;\n', '\n', '    }\n', '}']