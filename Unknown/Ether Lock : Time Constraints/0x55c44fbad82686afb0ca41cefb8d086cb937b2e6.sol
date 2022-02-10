['pragma solidity ^0.4.4;\n', '\n', 'contract Token {\n', '    function transfer(address _to, uint _value) returns (bool);\n', '    function balanceOf(address owner) returns(uint);\n', '}\n', '\n', '\n', 'contract Owned {\n', '    address public owner;\n', '\n', '    function Owned() {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner() {\n', '        if (msg.sender != owner) throw;\n', '        _;\n', '    }\n', '\n', '    address newOwner;\n', '\n', '    function changeOwner(address _newOwner) onlyOwner {\n', '        newOwner = _newOwner;\n', '    }\n', '\n', '    function acceptOwnership() {\n', '        if (msg.sender == newOwner) {\n', '            owner = newOwner;\n', '        }\n', '    }\n', '}\n', '\n', 'contract TokenReceivable is Owned {\n', '    event logTokenTransfer(address token, address to, uint amount);\n', '\n', '    function claimTokens(address _token, address _to) onlyOwner returns (bool) {\n', '        Token token = Token(_token);\n', '        uint balance = token.balanceOf(this);\n', '        if (token.transfer(_to, balance)) {\n', '            logTokenTransfer(_token, _to, balance);\n', '            return true;\n', '        }\n', '        return false;\n', '    }\n', '}\n', '\n', 'contract FunFairSale is Owned, TokenReceivable {\n', '    uint public deadline = 1499436000;\n', '    uint public startTime = 1498140000;\n', '    uint public capAmount;\n', '\n', '    function FunFairSale() {}\n', '\n', '    function setSoftCapDeadline(uint t) onlyOwner {\n', '        if (t > deadline) throw;\n', '        deadline = t;\n', '    }\n', '\n', '    function launch(uint _cap) onlyOwner {\n', '        capAmount = _cap;\n', '    }\n', '\n', '    function () payable {\n', '        if (block.timestamp < startTime || block.timestamp >= deadline) throw;\n', '\n', '        if (this.balance > capAmount) {\n', '            deadline = block.timestamp - 1;\n', '        }\n', '    }\n', '\n', '    function withdraw() onlyOwner {\n', '        if (block.timestamp < deadline) throw;\n', '\n', '        //testing return value doesn&#39;t do anything here\n', '        //but it stops a compiler warning\n', '        if (!owner.call.value(this.balance)()) throw;\n', '    }\n', '\n', '    function setStartTime(uint _startTime, uint _deadline) onlyOwner {\n', '        if (block.timestamp >= startTime) throw;\n', '        startTime = _startTime;\n', '        deadline = _deadline;\n', '    }\n', '\n', '}']
['pragma solidity ^0.4.4;\n', '\n', 'contract Token {\n', '    function transfer(address _to, uint _value) returns (bool);\n', '    function balanceOf(address owner) returns(uint);\n', '}\n', '\n', '\n', 'contract Owned {\n', '    address public owner;\n', '\n', '    function Owned() {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner() {\n', '        if (msg.sender != owner) throw;\n', '        _;\n', '    }\n', '\n', '    address newOwner;\n', '\n', '    function changeOwner(address _newOwner) onlyOwner {\n', '        newOwner = _newOwner;\n', '    }\n', '\n', '    function acceptOwnership() {\n', '        if (msg.sender == newOwner) {\n', '            owner = newOwner;\n', '        }\n', '    }\n', '}\n', '\n', 'contract TokenReceivable is Owned {\n', '    event logTokenTransfer(address token, address to, uint amount);\n', '\n', '    function claimTokens(address _token, address _to) onlyOwner returns (bool) {\n', '        Token token = Token(_token);\n', '        uint balance = token.balanceOf(this);\n', '        if (token.transfer(_to, balance)) {\n', '            logTokenTransfer(_token, _to, balance);\n', '            return true;\n', '        }\n', '        return false;\n', '    }\n', '}\n', '\n', 'contract FunFairSale is Owned, TokenReceivable {\n', '    uint public deadline = 1499436000;\n', '    uint public startTime = 1498140000;\n', '    uint public capAmount;\n', '\n', '    function FunFairSale() {}\n', '\n', '    function setSoftCapDeadline(uint t) onlyOwner {\n', '        if (t > deadline) throw;\n', '        deadline = t;\n', '    }\n', '\n', '    function launch(uint _cap) onlyOwner {\n', '        capAmount = _cap;\n', '    }\n', '\n', '    function () payable {\n', '        if (block.timestamp < startTime || block.timestamp >= deadline) throw;\n', '\n', '        if (this.balance > capAmount) {\n', '            deadline = block.timestamp - 1;\n', '        }\n', '    }\n', '\n', '    function withdraw() onlyOwner {\n', '        if (block.timestamp < deadline) throw;\n', '\n', "        //testing return value doesn't do anything here\n", '        //but it stops a compiler warning\n', '        if (!owner.call.value(this.balance)()) throw;\n', '    }\n', '\n', '    function setStartTime(uint _startTime, uint _deadline) onlyOwner {\n', '        if (block.timestamp >= startTime) throw;\n', '        startTime = _startTime;\n', '        deadline = _deadline;\n', '    }\n', '\n', '}']