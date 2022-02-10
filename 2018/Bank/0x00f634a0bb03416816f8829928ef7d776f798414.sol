['pragma solidity ^0.4.25;\n', 'contract ERC20 {\n', '    function balanceOf(address who) public view returns(uint);\n', '    function transfer(address to, uint value) public returns(bool);\n', '}\n', 'contract KiOS {\n', '    address public admin;\n', '    mapping(address => uint) public rates;\n', '    event Purchase(address indexed payer, address indexed token, uint price, uint amount);\n', '    event Received(address indexed sender, address indexed token, uint amount);\n', '    event Sent(address indexed recipient, address indexed token, uint amount);\n', '    constructor() public {\n', '        admin = msg.sender;\n', '    }\n', '    modifier restrict() {\n', '        require(msg.sender == admin);\n', '        _;\n', '    }\n', '    function check(address who) internal view returns(bool) {\n', '        if (who != address(0) && address(this) != who) return true;\n', '        else return false;\n', '    }\n', '    function getBalance(address token) internal view returns(uint) {\n', '        if (address(0) == token) return address(this).balance;\n', '        else return ERC20(token).balanceOf(address(this));\n', '    }\n', '    function changeAdmin(address newAdmin) public restrict returns(bool) {\n', '        require(check(newAdmin));\n', '        admin = newAdmin;\n', '        return true;\n', '    }\n', '    function() public payable {\n', '        if (msg.value > 0) payment();\n', '    }\n', '    function payment() public payable returns(bool) {\n', '        require(msg.value > 0);\n', '        emit Received(msg.sender, address(0), msg.value);\n', '        return true;\n', '    }\n', '    function pay(address recipient, address token, uint amount) public restrict returns(bool) {\n', '        require(check(recipient) && amount > 0 && amount <= getBalance(token));\n', '        if (address(0) == token) recipient.transfer(amount);\n', '        else if (!ERC20(token).transfer(recipient, amount)) revert();\n', '        emit Sent(recipient, token, amount);\n', '        return true;\n', '    }\n', '    function setRate(address token, uint price) public restrict returns(bool) {\n', '        require(check(token));\n', '        rates[token] = price;\n', '        return true;\n', '    }\n', '    function buy(address token) public payable returns(bool) {\n', '        require(check(token) && msg.value > 0);\n', '        require(getBalance(token) > 0 && rates[token] > 0);\n', '        uint valueEther = msg.value;\n', '        uint valueToken = valueEther * rates[token];\n', '        uint stock = getBalance(token);\n', '        if (valueToken > stock) {\n', '            msg.sender.transfer(valueEther - (stock / rates[token]));\n', '            valueToken = stock;\n', '        }\n', '        if (!ERC20(token).transfer(msg.sender, valueToken)) revert();\n', '        emit Purchase(msg.sender, token, rates[token], valueToken);\n', '        return true;\n', '    }\n', '}']