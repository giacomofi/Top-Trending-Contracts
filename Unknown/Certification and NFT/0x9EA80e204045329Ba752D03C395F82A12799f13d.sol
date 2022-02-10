['//--------------------------------------------------------------//\n', '//---------------------BLOCKLANCER TOKEN -----------------------//\n', '//--------------------------------------------------------------//\n', '\n', 'pragma solidity ^0.4.8;\n', '\n', '/// Migration Agent\n', '/// allows us to migrate to a new contract should it be needed\n', '/// makes blocklancer future proof\n', 'contract MigrationAgent {\n', '    function migrateFrom(address _from, uint256 _value);\n', '}\n', '\n', 'contract ERC20Interface {\n', '     // Get the total token supply\n', '     function totalSupply() constant returns (uint256 totalSupply);\n', '  \n', '     // Get the account balance of another account with address _owner\n', '     function balanceOf(address _owner) constant returns (uint256 balance);\n', '  \n', '     // Send _value amount of tokens to address _to\n', '     function transfer(address _to, uint256 _value) returns (bool success);\n', '  \n', '     // Send _value amount of tokens from address _from to address _to\n', '     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);\n', '  \n', '     // Allow _spender to withdraw from your account, multiple times, up to the _value amount.\n', '     // If this function is called again it overwrites the current allowance with _value.\n', '     // this function is required for some DEX functionality\n', '     function approve(address _spender, uint256 _value) returns (bool success);\n', '  \n', '     // Returns the amount which _spender is still allowed to withdraw from _owner\n', '     function allowance(address _owner, address _spender) constant returns (uint256 remaining);\n', '  \n', '     // Triggered when tokens are transferred.\n', '     event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '  \n', '     // Triggered whenever approve(address _spender, uint256 _value) is called.\n', '     event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}\n', '\n', '/// Blocklancer Token (LNC) - crowdfunding code for Blocklancer Project\n', 'contract BlocklancerToken is ERC20Interface {\n', '    string public constant name = "Lancer Token";\n', '    string public constant symbol = "LNC";\n', '    uint8 public constant decimals = 18;  // 18 decimal places, the same as ETH.\n', '\n', '    // The funding cap in weis.\n', '    uint256 public constant tokenCreationCap = 1000000000* 10**18;\n', '    uint256 public constant tokenCreationMin = 150000000* 10**18;\n', '    \n', '    mapping(address => mapping (address => uint256)) allowed;\n', '\n', '    uint public fundingStart;\n', '    uint public fundingEnd;\n', '\n', '    // The flag indicates if the LNC contract is in Funding state.\n', '    bool public funding = true;\n', '\n', '    // Receives ETH and its own LNC endowment.\n', '    address public master;\n', '\n', '    // The current total token supply.\n', '    uint256 totalTokens;\n', '    \n', '    //needed to calculate the price after the power day\n', '    //the price increases by 1 % for every 10 million LNC sold after power day\n', '    uint256 soldAfterPowerHour;\n', '\n', '    mapping (address => uint256) balances;\n', '    mapping (address => uint) lastTransferred;\n', '    \n', '    //needed to refund everyone should the ICO fail\n', '    // needed because the price per LNC isn&#39;t linear\n', '    mapping (address => uint256) balancesEther;\n', '\n', '    //address of the contract that manages the migration\n', '    //can only be changed by the creator\n', '    address public migrationAgent;\n', '    \n', '    //total amount of token migrated\n', '    //allows everyone to see the progress of the migration\n', '    uint256 public totalMigrated;\n', '\n', '    event Migrate(address indexed _from, address indexed _to, uint256 _value);\n', '    event Refund(address indexed _from, uint256 _value);\n', '    \n', '    //total amount of participants in the ICO\n', '    uint totalParticipants;\n', '\n', '    function BlocklancerToken() {\n', '        master = msg.sender;\n', '        fundingStart = 1501977600;\n', '        //change first number!\n', '        fundingEnd = fundingStart + 31 * 1 days;//now + 1000 * 1 minutes;\n', '    }\n', '    \n', '    //returns the total amount of participants in the ICO\n', '    function getAmountofTotalParticipants() constant returns (uint){\n', '        return totalParticipants;\n', '    }\n', '    \n', '    //set\n', '    function getAmountSoldAfterPowerDay() constant external returns(uint256){\n', '        return soldAfterPowerHour;\n', '    }\n', '\n', '    /// allows to transfer token to another address\n', '    function transfer(address _to, uint256 _value) returns (bool success) {\n', '        // Don&#39;t allow in funding state\n', '        if(funding) throw;\n', '\n', '        var senderBalance = balances[msg.sender];\n', '        //only allow if the balance of the sender is more than he want&#39;s to send\n', '        if (senderBalance >= _value && _value > 0) {\n', '            //reduce the sender balance by the amount he sends\n', '            senderBalance -= _value;\n', '            balances[msg.sender] = senderBalance;\n', '            \n', '            //increase the balance of the receiver by the amount we reduced the balance of the sender\n', '            balances[_to] += _value;\n', '            \n', '            //saves the last time someone sent LNc from this address\n', '            //is needed for our Token Holder Tribunal\n', '            //this ensures that everyone can only vote one time\n', '            //otherwise it would be possible to send the LNC around and everyone votes again and again\n', '            lastTransferred[msg.sender]=block.timestamp;\n', '            Transfer(msg.sender, _to, _value);\n', '            return true;\n', '        }\n', '        //transfer failed\n', '        return false;\n', '    }\n', '\n', '    //returns the total amount of LNC in circulation\n', '    //get displayed on the website whilst the crowd funding\n', '    function totalSupply() constant returns (uint256 totalSupply) {\n', '        return totalTokens;\n', '    }\n', '    \n', '    //retruns the balance of the owner address\n', '    function balanceOf(address _owner) constant returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '    \n', '    //returns the amount anyone pledged into this contract\n', '    function EtherBalanceOf(address _owner) constant returns (uint256) {\n', '        return balancesEther[_owner];\n', '    }\n', '    \n', '    //time left before the crodsale ends\n', '    function TimeLeft() external constant returns (uint256) {\n', '        if(fundingEnd>block.timestamp)\n', '            return fundingEnd-block.timestamp;\n', '        else\n', '            return 0;\n', '    }\n', '    \n', '    //time left before the crodsale begins\n', '    function TimeLeftBeforeCrowdsale() external constant returns (uint256) {\n', '        if(fundingStart>block.timestamp)\n', '            return fundingStart-block.timestamp;\n', '        else\n', '            return 0;\n', '    }\n', '\n', '    // allows us to migrate to anew contract\n', '    function migrate(uint256 _value) external {\n', '        // can only be called if the funding ended\n', '        if(funding) throw;\n', '        \n', '        //the migration agent address needs to be set\n', '        if(migrationAgent == 0) throw;\n', '\n', '        // must migrate more than nothing\n', '        if(_value == 0) throw;\n', '        \n', '        //if the value is higher than the sender owns abort\n', '        if(_value > balances[msg.sender]) throw;\n', '\n', '        //reduce the balance of the owner\n', '        balances[msg.sender] -= _value;\n', '        \n', '        //reduce the token left in the old contract\n', '        totalTokens -= _value;\n', '        totalMigrated += _value;\n', '        \n', '        //call the migration agent to complete the migration\n', '        //credits the same amount of LNC in the new contract\n', '        MigrationAgent(migrationAgent).migrateFrom(msg.sender, _value);\n', '        Migrate(msg.sender, migrationAgent, _value);\n', '    }\n', '\n', '    //sets the address of the migration agent\n', '    function setMigrationAgent(address _agent) external {\n', '        //not possible in funding mode\n', '        if(funding) throw;\n', '        \n', '        //only allow to set this once\n', '        if(migrationAgent != 0) throw;\n', '        \n', '        //anly the owner can call this function\n', '        if(msg.sender != master) throw;\n', '        \n', '        //set the migration agent\n', '        migrationAgent = _agent;\n', '    }\n', '    \n', '    //return the current exchange rate -> LNC per Ether\n', '    function getExchangeRate() constant returns(uint){\n', '        //15000 LNC at power day\n', '        if(fundingStart + 1 * 1 days > block.timestamp){\n', '            return 15000;\n', '        }\n', '        //otherwise reduce by 1 % every 10 million LNC sold\n', '        else{\n', '            uint256 decrease=100-(soldAfterPowerHour/10000000/1000000000000000000);\n', '            if(decrease<70){\n', '                decrease=70;\n', '            }\n', '            return 10000*decrease/100;\n', '        }\n', '    }\n', '    \n', '    //returns if the crowd sale is still open\n', '    function ICOopen() constant returns(bool){\n', '        if(!funding) return false;\n', '        else if(block.timestamp < fundingStart) return false;\n', '        else if(block.timestamp > fundingEnd) return false;\n', '        else if(tokenCreationCap <= totalTokens) return false;\n', '        else return true;\n', '    }\n', '\n', '    // Crowdfunding:\n', '\n', '    //when someone send ether to this contract\n', '    function() payable external {\n', '        //not possible if the funding has ended\n', '        if(!funding) throw;\n', '        \n', '        //not possible before the funding started\n', '        if(block.timestamp < fundingStart) throw;\n', '        \n', '        //not possible after the funding ended\n', '        if(block.timestamp > fundingEnd) throw;\n', '\n', '        // Do not allow creating 0 or more than the cap tokens.\n', '        if(msg.value == 0) throw;\n', '        \n', '        //don&#39;t allow to create more token than the maximum cap\n', '        if((msg.value  * getExchangeRate()) > (tokenCreationCap - totalTokens)) throw;\n', '\n', '        //calculate the amount of LNC the sender receives\n', '        var numTokens = msg.value * getExchangeRate();\n', '        totalTokens += numTokens;\n', '        \n', '        //increase the amount of token sold after power day\n', '        //allows us to calculate the 1 % price increase per 10 million LNC sold\n', '        if(getExchangeRate()!=15000){\n', '            soldAfterPowerHour += numTokens;\n', '        }\n', '\n', '        // increase the amount of token the sender holds\n', '        balances[msg.sender] += numTokens;\n', '        \n', '        //increase the amount of ether the sender pledged into the contract\n', '        balancesEther[msg.sender] += msg.value;\n', '        \n', '        //icrease the amount of people that sent ether to this contract\n', '        totalParticipants+=1;\n', '\n', '        // Log token creation\n', '        Transfer(0, msg.sender, numTokens);\n', '    }\n', '\n', '    //called after the crodsale ended\n', '    //needed to allow everyone to send their LNC around\n', '    function finalize() external {\n', '        // not possible if the funding already ended\n', '        if(!funding) throw;\n', '        \n', '        //only possible if funding ended and the minimum cap is reached - or\n', '        //the total amount of token is the same as the maximum cap\n', '        if((block.timestamp <= fundingEnd ||\n', '             totalTokens < tokenCreationMin) &&\n', '            (totalTokens+5000000000000000000000) < tokenCreationCap) throw;\n', '\n', '        // allows to tranfer token to another address\n', '        // disables buying LNC\n', '        funding = false;\n', '\n', '        //send 12% of the token to the devs\n', '        //10 % for the devs\n', '        //2 % for the bounty participants\n', '        uint256 percentOfTotal = 12;\n', '        uint256 additionalTokens = totalTokens * percentOfTotal / (100 - percentOfTotal);\n', '        totalTokens += additionalTokens;\n', '        balances[master] += additionalTokens;\n', '        Transfer(0, master, additionalTokens);\n', '\n', '        // Transfer ETH to the Blocklancer address.\n', '        if (!master.send(this.balance)) throw;\n', '    }\n', '\n', '    //everyone needs to call this function should the minimum cap not be reached\n', '    //refunds the sender\n', '    function refund() external {\n', '        // not possible after the ICO was finished\n', '        if(!funding) throw;\n', '        \n', '        //not possible before the ICO ended\n', '        if(block.timestamp <= fundingEnd) throw;\n', '        \n', '        //not possible if more token were created than the minimum\n', '        if(totalTokens >= tokenCreationMin) throw;\n', '\n', '        var lncValue = balances[msg.sender];\n', '        var ethValue = balancesEther[msg.sender];\n', '        if (lncValue == 0) throw;\n', '        \n', '        //set the amount of token the sender has to 0\n', '        balances[msg.sender] = 0;\n', '        \n', '        //set the amount of ether the sender owns to 0\n', '        balancesEther[msg.sender] = 0;\n', '        totalTokens -= lncValue;\n', '\n', '        Refund(msg.sender, ethValue);\n', '        if (!msg.sender.send(ethValue)) throw;\n', '    }\n', '\t\n', '    // Send _value amount of tokens from address _from to address _to\n', '    // The transferFrom method is used for a withdraw workflow, allowing contracts to send\n', '     // tokens on your behalf, for example to "deposit" to a contract address and/or to charge\n', '     // fees in sub-currencies; the command should fail unless the _from account has\n', '     // deliberately authorized the sender of the message via some mechanism; we propose\n', '     // these standardized APIs for approval:\n', '     function transferFrom(address _from,address _to,uint256 _amount) returns (bool success) {\n', '         if(funding) throw;\n', '         if (balances[_from] >= _amount\n', '             && allowed[_from][msg.sender] >= _amount\n', '             && _amount > 0\n', '             && balances[_to] + _amount > balances[_to]) {\n', '             balances[_from] -= _amount;\n', '             allowed[_from][msg.sender] -= _amount;\n', '             balances[_to] += _amount;\n', '             Transfer(_from, _to, _amount);\n', '             return true;\n', '         } else {\n', '             return false;\n', '         }\n', '     }\n', '  \n', '     // Allow _spender to withdraw from your account, multiple times, up to the _value amount.\n', '     // If this function is called again it overwrites the current allowance with _value.\n', '     function approve(address _spender, uint256 _amount) returns (bool success) {\n', '         if(funding) throw;\n', '         allowed[msg.sender][_spender] = _amount;\n', '         Approval(msg.sender, _spender, _amount);\n', '         return true;\n', '     }\n', '  \n', '     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {\n', '         return allowed[_owner][_spender];\n', '     }\n', '}']