['pragma solidity ^ 0.4.4;\n', '\n', '/*\n', 'This is the smart contract for the ERC 20 standard Tratok token.\n', 'During development of the smart contract, active attention was paid to make the contract as simple as possible.\n', 'As the majority of functions are simple addition and subtraction of existing balances, we have been able to make the contract very lightweight.\n', 'This has the added advantage of reducing gas costs and ensuring that transaction fees remain low.\n', 'The smart contract has been made publically available, keeping with the team&#39;s philosophy of transparency.\n', 'This is an update on the original smart contract which can be found at 0xDaaab43c2Df2588980826e3C8d46828FC0b44bFe.\n', 'The contract has been updated to match a change in project philosophy and enhance distribution and widespread adoption of the token via free airdrops.\n', '\n', '@version "1.1"\n', '@developer "Tratok Team"\n', '@date "22 September 2018"\n', '@thoughts "227 lines that can change the travel and tourism industry! Good luck!"\n', '*/\n', '\n', '/*\n', ' * Use of the SafeMath Library prevents malicious input. For security consideration, the\n', ' * smart contaract makes use of .add() and .sub() rather than += and -=\n', ' */\n', '\n', 'library SafeMath {\n', '    \n', '\t//Ensures that b is greater than a to handle negatives.\n', '    function sub(uint256 a, uint256 b) internal returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    //Ensures that the sum of two values is greater than the intial value.\n', '    function add(uint256 a, uint256 b) internal returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', '/*\n', ' * ERC20 Standard will be used\n', ' * see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', '\n', 'contract ERC20 {\n', '    //the total supply of tokens\t\n', '    uint public totalSupply;\n', '\n', '    //@return Returns the total amount of Tratok tokens in existence. The amount remains capped at the pre-created 100 Billion.  \n', '    function totalSupply() constant returns(uint256 supply){}\n', '\n', '    /* \n', '      @param _owner The address of the wallet which needs to be queried for the amount of Tratok held. \n', '      @return Returns the balance of Tratok tokens for the relevant address.\n', '      */\n', '    function balanceOf(address who) constant returns(uint);\n', '\n', '    /*\t\n', '       The transfer function which takes the address of the recipient and the amount of Tratok needed to be sent and complete the transfer\n', '       @param _to The address of the recipient (usually a "service provider") who will receive the Tratok.\n', '       @param _value The amount of Tratok that needs to be transferred.\n', '       @return Returns a boolean value to verify the transaction has succeeded or failed.\n', '      */\n', '    function transfer(address to, uint value) returns(bool ok);\n', '\n', '    /*\n', '       This function will, conditional of being approved by the holder, send a determined amount of tokens to a specified address\n', '       @param _from The address of the Tratok sender.\n', '       @param _to The address of the Tratok recipient.\n', '       @param _value The volume (amount of Tratok which will be sent).\n', '       @return Returns a boolean value to verify the transaction has succeeded or failed.\n', '      */\n', '    function transferFrom(address from, address to, uint value) returns(bool ok);\n', '\n', '    /*\n', '      This function approves the transaction and costs\n', '      @param _spender The address of the account which is able to transfer the tokens\n', '      @param _value The amount of wei to be approved for transfer\n', '      @return Whether the approval was successful or not\n', '     */\n', '    function approve(address spender, uint value) returns(bool ok);\n', '\n', '    /*\n', '    This function determines how many Tratok remain and how many can be spent.\n', '     @param _owner The address of the account owning the Tratok tokens\n', '     @param _spender The address of the account which is authorized to spend the Tratok tokens\n', '     @return Amount of Tratok tokens which remain available and therefore, which can be spent\n', '    */\n', '    function allowance(address owner, address spender) constant returns(uint);\n', '\n', '\n', '    event Transfer(address indexed from, address indexed to, uint value);\n', '    event Approval(address indexed owner, address indexed spender, uint value);\n', '\n', '}\n', '\n', '/*\n', ' *This is a basic contract held by one owner and prevents function execution if attempts to run are made by anyone other than the owner of the contract\n', ' */\n', '\n', 'contract Ownable {\n', '    address public owner;\n', '\n', '    function Ownable() {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner() {\n', '        if (msg.sender != owner) {\n', '            throw;\n', '        }\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address newOwner) onlyOwner {\n', '        if (newOwner != address(0)) {\n', '            owner = newOwner;\n', '        }\n', '    }\n', '\n', '}\n', '\n', 'contract StandardToken is ERC20, Ownable {\n', '\tusing SafeMath for uint256;\n', '    function transfer(address _to, uint256 _value) returns(bool success) {\n', '        if (balances[msg.sender] >= _value && _value > 0) {\n', '            balances[msg.sender] = balances[msg.sender].sub(_value);\n', '            balances[_to] = balances[_to].add(_value);\n', '            Transfer(msg.sender, _to, _value);\n', '            return true;\n', '        } else {\n', '            return false;\n', '        }\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) returns(bool success) {\n', '        if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {\n', '            balances[_to] = balances[_to].add(_value);\n', '            balances[_from] = balances[_from].sub(_value);\n', '            allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '            Transfer(_from, _to, _value);\n', '            return true;\n', '        } else {\n', '            return false;\n', '        }\n', '    }\n', '\n', '    function balanceOf(address _owner) constant returns(uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) returns(bool success) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) constant returns(uint256 remaining) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    /*\n', '\tThis function determines distributes tratok to multiple addresses.\n', '     @param _destinations The address of the accounts which will be sent Tratok tokens.\n', '     @param _values The amount of the Tratok tokens to be sent.\n', '     @return The number of loop cycles\n', '     */        \n', '    \n', '    function distributeTratok(address[] _destinations, uint256[] _values)\n', '    returns (uint256) {\n', '        uint256 i = 0;\n', '        while (i < _destinations.length) {\n', '           transfer(_destinations[i], _values[i]);\n', '           i += 1;\n', '        }\n', '        return(i);\n', '    }    \n', '    \n', '\n', '    mapping(address => uint256) balances;\n', '    mapping(address => mapping(address => uint256)) allowed;\n', '    uint256 public totalSupply;\n', '}\n', '\n', 'contract Tratok is StandardToken {\n', '\n', '    function() {\n', '        throw;\n', '    }\n', '\n', '    /* \n', '     * The public variables of the token. Inclduing the name, the symbol and the number of decimals.\n', '     */\n', '    string public name;\n', '    uint8 public decimals;\n', '    string public symbol;\n', '    string public version = &#39;H1.0&#39;;\n', '\n', '    /*\n', '     * Declaring the customized details of the token. The token will be called Tratok, with a total supply of 100 billion tokens.\n', '     * It will feature five decimal places and have the symbol TRAT.\n', '     */\n', '\n', '    function Tratok() {\n', '\n', '        //we will create 100 Billion Coins and send them to the creating wallet.\n', '        balances[msg.sender] = 10000000000000000;\n', '        totalSupply = 10000000000000000;\n', '        name = "Tratok";\n', '        decimals = 5;\n', '        symbol = "TRAT";\n', '    }\n', '\n', '    /*\n', '     *Approve and enact the contract.\n', '     *\n', '     */\n', '    function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns(bool success) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '\n', '        //If the call fails, result to "vanilla" approval.\n', '        if (!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) {\n', '            throw;\n', '        }\n', '        return true;\n', '    }    \n', '}']
['pragma solidity ^ 0.4.4;\n', '\n', '/*\n', 'This is the smart contract for the ERC 20 standard Tratok token.\n', 'During development of the smart contract, active attention was paid to make the contract as simple as possible.\n', 'As the majority of functions are simple addition and subtraction of existing balances, we have been able to make the contract very lightweight.\n', 'This has the added advantage of reducing gas costs and ensuring that transaction fees remain low.\n', "The smart contract has been made publically available, keeping with the team's philosophy of transparency.\n", 'This is an update on the original smart contract which can be found at 0xDaaab43c2Df2588980826e3C8d46828FC0b44bFe.\n', 'The contract has been updated to match a change in project philosophy and enhance distribution and widespread adoption of the token via free airdrops.\n', '\n', '@version "1.1"\n', '@developer "Tratok Team"\n', '@date "22 September 2018"\n', '@thoughts "227 lines that can change the travel and tourism industry! Good luck!"\n', '*/\n', '\n', '/*\n', ' * Use of the SafeMath Library prevents malicious input. For security consideration, the\n', ' * smart contaract makes use of .add() and .sub() rather than += and -=\n', ' */\n', '\n', 'library SafeMath {\n', '    \n', '\t//Ensures that b is greater than a to handle negatives.\n', '    function sub(uint256 a, uint256 b) internal returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    //Ensures that the sum of two values is greater than the intial value.\n', '    function add(uint256 a, uint256 b) internal returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', '/*\n', ' * ERC20 Standard will be used\n', ' * see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', '\n', 'contract ERC20 {\n', '    //the total supply of tokens\t\n', '    uint public totalSupply;\n', '\n', '    //@return Returns the total amount of Tratok tokens in existence. The amount remains capped at the pre-created 100 Billion.  \n', '    function totalSupply() constant returns(uint256 supply){}\n', '\n', '    /* \n', '      @param _owner The address of the wallet which needs to be queried for the amount of Tratok held. \n', '      @return Returns the balance of Tratok tokens for the relevant address.\n', '      */\n', '    function balanceOf(address who) constant returns(uint);\n', '\n', '    /*\t\n', '       The transfer function which takes the address of the recipient and the amount of Tratok needed to be sent and complete the transfer\n', '       @param _to The address of the recipient (usually a "service provider") who will receive the Tratok.\n', '       @param _value The amount of Tratok that needs to be transferred.\n', '       @return Returns a boolean value to verify the transaction has succeeded or failed.\n', '      */\n', '    function transfer(address to, uint value) returns(bool ok);\n', '\n', '    /*\n', '       This function will, conditional of being approved by the holder, send a determined amount of tokens to a specified address\n', '       @param _from The address of the Tratok sender.\n', '       @param _to The address of the Tratok recipient.\n', '       @param _value The volume (amount of Tratok which will be sent).\n', '       @return Returns a boolean value to verify the transaction has succeeded or failed.\n', '      */\n', '    function transferFrom(address from, address to, uint value) returns(bool ok);\n', '\n', '    /*\n', '      This function approves the transaction and costs\n', '      @param _spender The address of the account which is able to transfer the tokens\n', '      @param _value The amount of wei to be approved for transfer\n', '      @return Whether the approval was successful or not\n', '     */\n', '    function approve(address spender, uint value) returns(bool ok);\n', '\n', '    /*\n', '    This function determines how many Tratok remain and how many can be spent.\n', '     @param _owner The address of the account owning the Tratok tokens\n', '     @param _spender The address of the account which is authorized to spend the Tratok tokens\n', '     @return Amount of Tratok tokens which remain available and therefore, which can be spent\n', '    */\n', '    function allowance(address owner, address spender) constant returns(uint);\n', '\n', '\n', '    event Transfer(address indexed from, address indexed to, uint value);\n', '    event Approval(address indexed owner, address indexed spender, uint value);\n', '\n', '}\n', '\n', '/*\n', ' *This is a basic contract held by one owner and prevents function execution if attempts to run are made by anyone other than the owner of the contract\n', ' */\n', '\n', 'contract Ownable {\n', '    address public owner;\n', '\n', '    function Ownable() {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner() {\n', '        if (msg.sender != owner) {\n', '            throw;\n', '        }\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address newOwner) onlyOwner {\n', '        if (newOwner != address(0)) {\n', '            owner = newOwner;\n', '        }\n', '    }\n', '\n', '}\n', '\n', 'contract StandardToken is ERC20, Ownable {\n', '\tusing SafeMath for uint256;\n', '    function transfer(address _to, uint256 _value) returns(bool success) {\n', '        if (balances[msg.sender] >= _value && _value > 0) {\n', '            balances[msg.sender] = balances[msg.sender].sub(_value);\n', '            balances[_to] = balances[_to].add(_value);\n', '            Transfer(msg.sender, _to, _value);\n', '            return true;\n', '        } else {\n', '            return false;\n', '        }\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) returns(bool success) {\n', '        if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {\n', '            balances[_to] = balances[_to].add(_value);\n', '            balances[_from] = balances[_from].sub(_value);\n', '            allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '            Transfer(_from, _to, _value);\n', '            return true;\n', '        } else {\n', '            return false;\n', '        }\n', '    }\n', '\n', '    function balanceOf(address _owner) constant returns(uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) returns(bool success) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) constant returns(uint256 remaining) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    /*\n', '\tThis function determines distributes tratok to multiple addresses.\n', '     @param _destinations The address of the accounts which will be sent Tratok tokens.\n', '     @param _values The amount of the Tratok tokens to be sent.\n', '     @return The number of loop cycles\n', '     */        \n', '    \n', '    function distributeTratok(address[] _destinations, uint256[] _values)\n', '    returns (uint256) {\n', '        uint256 i = 0;\n', '        while (i < _destinations.length) {\n', '           transfer(_destinations[i], _values[i]);\n', '           i += 1;\n', '        }\n', '        return(i);\n', '    }    \n', '    \n', '\n', '    mapping(address => uint256) balances;\n', '    mapping(address => mapping(address => uint256)) allowed;\n', '    uint256 public totalSupply;\n', '}\n', '\n', 'contract Tratok is StandardToken {\n', '\n', '    function() {\n', '        throw;\n', '    }\n', '\n', '    /* \n', '     * The public variables of the token. Inclduing the name, the symbol and the number of decimals.\n', '     */\n', '    string public name;\n', '    uint8 public decimals;\n', '    string public symbol;\n', "    string public version = 'H1.0';\n", '\n', '    /*\n', '     * Declaring the customized details of the token. The token will be called Tratok, with a total supply of 100 billion tokens.\n', '     * It will feature five decimal places and have the symbol TRAT.\n', '     */\n', '\n', '    function Tratok() {\n', '\n', '        //we will create 100 Billion Coins and send them to the creating wallet.\n', '        balances[msg.sender] = 10000000000000000;\n', '        totalSupply = 10000000000000000;\n', '        name = "Tratok";\n', '        decimals = 5;\n', '        symbol = "TRAT";\n', '    }\n', '\n', '    /*\n', '     *Approve and enact the contract.\n', '     *\n', '     */\n', '    function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns(bool success) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '\n', '        //If the call fails, result to "vanilla" approval.\n', '        if (!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) {\n', '            throw;\n', '        }\n', '        return true;\n', '    }    \n', '}']
