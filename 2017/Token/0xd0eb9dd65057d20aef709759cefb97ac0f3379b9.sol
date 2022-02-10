['contract IToken {\n', '    function totalSupply() constant returns (uint256 supply) {}\n', '    function balanceOf(address _owner) constant returns (uint256 balance) {}\n', '    function transferViaProxy(address _from, address _to, uint _value) returns (uint error) {}\n', '    function transferFromViaProxy(address _source, address _from, address _to, uint256 _amount) returns (uint error) {}\n', '    function approveFromProxy(address _source, address _spender, uint256 _value) returns (uint error) {}\n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}\n', '    function issueNewCoins(address _destination, uint _amount) returns (uint error){}\n', '    function issueNewHeldCoins(address _destination, uint _amount){}\n', '    function destroyOldCoins(address _destination, uint _amount) returns (uint error) {}\n', '    function takeTokensForBacking(address _destination, uint _amount){}\n', '}\n', '\n', '\n', 'contract DestructionContract{\n', '\n', '    address public curator;\n', '    address public dev;\n', '    IToken tokenContract;\n', '\n', '    function DestructionContract(){\n', '        dev = msg.sender;\n', '    }\n', '\n', '    function destroy(uint _amount){\n', '        if (msg.sender != curator) throw;\n', '\n', '        tokenContract.destroyOldCoins(msg.sender, _amount);\n', '    }\n', '\n', '    function setDestructionCurator(address _curatorAdress){\n', '        if (msg.sender != dev) throw;\n', '\n', '        curator = _curatorAdress;\n', '    }\n', '\n', '    function setTokenContract(address _contractAddress){\n', '        if (msg.sender != curator) throw;\n', '\n', '        tokenContract = IToken(_contractAddress);\n', '    }\n', '\n', '    function killContract(){\n', '        if (msg.sender != dev) throw;\n', '\n', '        selfdestruct(dev);\n', '    }\n', '\n', '    function tokenAddress() constant returns (address tokenAddress){\n', '        return address(tokenContract);\n', '    }\n', '}']
['contract IToken {\n', '    function totalSupply() constant returns (uint256 supply) {}\n', '    function balanceOf(address _owner) constant returns (uint256 balance) {}\n', '    function transferViaProxy(address _from, address _to, uint _value) returns (uint error) {}\n', '    function transferFromViaProxy(address _source, address _from, address _to, uint256 _amount) returns (uint error) {}\n', '    function approveFromProxy(address _source, address _spender, uint256 _value) returns (uint error) {}\n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}\n', '    function issueNewCoins(address _destination, uint _amount) returns (uint error){}\n', '    function issueNewHeldCoins(address _destination, uint _amount){}\n', '    function destroyOldCoins(address _destination, uint _amount) returns (uint error) {}\n', '    function takeTokensForBacking(address _destination, uint _amount){}\n', '}\n', '\n', '\n', 'contract DestructionContract{\n', '\n', '    address public curator;\n', '    address public dev;\n', '    IToken tokenContract;\n', '\n', '    function DestructionContract(){\n', '        dev = msg.sender;\n', '    }\n', '\n', '    function destroy(uint _amount){\n', '        if (msg.sender != curator) throw;\n', '\n', '        tokenContract.destroyOldCoins(msg.sender, _amount);\n', '    }\n', '\n', '    function setDestructionCurator(address _curatorAdress){\n', '        if (msg.sender != dev) throw;\n', '\n', '        curator = _curatorAdress;\n', '    }\n', '\n', '    function setTokenContract(address _contractAddress){\n', '        if (msg.sender != curator) throw;\n', '\n', '        tokenContract = IToken(_contractAddress);\n', '    }\n', '\n', '    function killContract(){\n', '        if (msg.sender != dev) throw;\n', '\n', '        selfdestruct(dev);\n', '    }\n', '\n', '    function tokenAddress() constant returns (address tokenAddress){\n', '        return address(tokenContract);\n', '    }\n', '}']
