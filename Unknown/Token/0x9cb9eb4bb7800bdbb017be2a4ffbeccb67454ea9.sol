['pragma solidity ^ 0.4 .8;\n', '\n', '\n', 'contract ERC20 {\n', '\n', '    uint public totalSupply;\n', '\n', '    function balanceOf(address who) constant returns(uint256);\n', '\n', '    function allowance(address owner, address spender) constant returns(uint);\n', '\n', '    function transferFrom(address from, address to, uint value) returns(bool ok);\n', '\n', '    function approve(address spender, uint value) returns(bool ok);\n', '\n', '    function transfer(address to, uint value) returns(bool ok);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint value);\n', '\n', '    event Approval(address indexed owner, address indexed spender, uint value);\n', '\n', '}\n', '\n', 'contract blockoptions is ERC20\n', '\n', '{\n', '\n', '       /* Public variables of the token */\n', '      //To store name for token\n', '      string public name = "blockoptions";\n', '    \n', '      //To store symbol for token       \n', '      string public symbol = "BOPT";\n', '    \n', '      //To store decimal places for token\n', '      uint8 public decimals = 8;    \n', '    \n', '      //To store current supply of BOPT\n', '      uint public totalSupply=20000000 * 100000000;\n', '      \n', '       uint pre_ico_start;\n', '       uint pre_ico_end;\n', '       uint ico_start;\n', '       uint ico_end;\n', '       mapping(uint => address) investor;\n', '       mapping(uint => uint) weireceived;\n', '       mapping(uint => uint) optsSent;\n', '      \n', '        event preico(uint counter,address investors,uint weiReceived,uint boptsent);\n', '        event ico(uint counter,address investors,uint weiReceived,uint boptsent);\n', '        uint counter=0;\n', '        uint profit_sent=0;\n', '        bool stopped = false;\n', '        \n', '      function blockoptions() payable{\n', '          owner = msg.sender;\n', '          balances[owner] = totalSupply ; //to handle 8 decimal places\n', '          pre_ico_start = now;\n', '          pre_ico_end = pre_ico_start + 7 days;\n', '          \n', '        }\n', '      //map to store BOPT balance corresponding to address\n', '      mapping(address => uint) balances;\n', '    \n', '      //To store spender with allowed amount of BOPT to spend corresponding to BOPTs holder&#39;s account\n', '      mapping (address => mapping (address => uint)) allowed;\n', '    \n', '      //owner variable to store contract owner account\n', '      address public owner;\n', '      \n', '      //modifier to check transaction initiator is only owner\n', '      modifier onlyOwner() {\n', '        if (msg.sender == owner)\n', '          _;\n', '      }\n', '    \n', '      //ownership can be transferred to provided newOwner. Function can only be initiated by contract owner&#39;s account\n', '      function transferOwnership(address newOwner) onlyOwner {\n', '          balances[newOwner] = balances[owner];\n', '          balances[owner]=0;\n', '          owner = newOwner;\n', '      }\n', '\n', '        /**\n', '        * Multiplication with safety check\n', '        */\n', '        function Mul(uint a, uint b) internal returns (uint) {\n', '          uint c = a * b;\n', '          //check result should not be other wise until a=0\n', '          assert(a == 0 || c / a == b);\n', '          return c;\n', '        }\n', '    \n', '        /**\n', '        * Division with safety check\n', '        */\n', '        function Div(uint a, uint b) internal returns (uint) {\n', '          //overflow check; b must not be 0\n', '          assert(b > 0);\n', '          uint c = a / b;\n', '          assert(a == b * c + a % b);\n', '          return c;\n', '        }\n', '    \n', '        /**\n', '        * Subtraction with safety check\n', '        */\n', '        function Sub(uint a, uint b) internal returns (uint) {\n', '          //b must be greater that a as we need to store value in unsigned integer\n', '          assert(b <= a);\n', '          return a - b;\n', '        }\n', '    \n', '        /**\n', '        * Addition with safety check\n', '        */\n', '        function Add(uint a, uint b) internal returns (uint) {\n', '          uint c = a + b;\n', '          //result must be greater as a or b can not be negative\n', '          assert(c>=a && c>=b);\n', '          return c;\n', '        }\n', '    \n', '      /**\n', '        * assert used in different Math functions\n', '        */\n', '        function assert(bool assertion) internal {\n', '          if (!assertion) {\n', '            throw;\n', '          }\n', '        }\n', '    \n', '    //Implementation for transferring BOPT to provided address \n', '      function transfer(address _to, uint _value) returns (bool){\n', '\n', '        uint check = balances[owner] - _value;\n', '        if(msg.sender == owner && now>=pre_ico_start && now<=pre_ico_end && check < 1900000000000000)\n', '        {\n', '            return false;\n', '        }\n', '        else if(msg.sender ==owner && now>=pre_ico_end && now<=(pre_ico_end + 16 days) && check < 1850000000000000)\n', '        {\n', '            return false;\n', '        }\n', '        else if(msg.sender == owner && check < 150000000000000 && now < ico_start + 180 days)\n', '        {\n', '            return false;\n', '        }\n', '        else if (msg.sender == owner && check < 100000000000000 && now < ico_start + 360 days)\n', '        {\n', '            return false;\n', '        }\n', '        else if (msg.sender == owner && check < 50000000000000 && now < ico_start + 540 days)\n', '        {\n', '            return false;\n', '        }\n', '        //Check provided BOPT should not be 0\n', '       else if (_value > 0) {\n', '          //deduct OPTS amount from transaction initiator\n', '          balances[msg.sender] = Sub(balances[msg.sender],_value);\n', '          //Add OPTS to balace of target account\n', '          balances[_to] = Add(balances[_to],_value);\n', '          //Emit event for transferring BOPT\n', '          Transfer(msg.sender, _to, _value);\n', '          return true;\n', '        }\n', '        else{\n', '          return false;\n', '        }\n', '      }\n', '      \n', '      //Transfer initiated by spender \n', '      function transferFrom(address _from, address _to, uint _value) returns (bool) {\n', '    \n', '        //Check provided BOPT should not be 0\n', '        if (_value > 0) {\n', '          //Get amount of BOPT for which spender is authorized\n', '          var _allowance = allowed[_from][msg.sender];\n', '          //Add amount of BOPT in trarget account&#39;s balance\n', '          balances[_to] = Add(balances[_to], _value);\n', '          //Deduct BOPT amount from _from account\n', '          balances[_from] = Sub(balances[_from], _value);\n', '          //Deduct Authorized amount for spender\n', '          allowed[_from][msg.sender] = Sub(_allowance, _value);\n', '          //Emit event for Transfer\n', '          Transfer(_from, _to, _value);\n', '          return true;\n', '        }else{\n', '          return false;\n', '        }\n', '      }\n', '      \n', '      //Get BOPT balance for provided address\n', '      function balanceOf(address _owner) constant returns (uint balance) {\n', '        return balances[_owner];\n', '      }\n', '      \n', '      //Add spender to authorize for spending specified amount of BOPT \n', '      function approve(address _spender, uint _value) returns (bool) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        //Emit event for approval provided to spender\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '      }\n', '      \n', '      //Get BOPT amount that spender can spend from provided owner&#39;s account \n', '      function allowance(address _owner, address _spender) constant returns (uint remaining) {\n', '        return allowed[_owner][_spender];\n', '      }\n', '      \n', '       /*\t\n', '       * Failsafe drain\n', '       */\n', '    \tfunction drain() onlyOwner {\n', '    \t\towner.send(this.balance);\n', '    \t}\n', '\t\n', '    \tfunction() payable \n', '    \t{   \n', '    \t    if(stopped && msg.sender != owner)\n', '    \t    revert();\n', '    \t     else if(msg.sender == owner)\n', '    \t    {\n', '    \t        profit_sent = msg.value;\n', '    \t    }\n', '    \t   else if(now>=pre_ico_start && now<=pre_ico_end)\n', '    \t    {\n', '    \t        uint check = balances[owner]-((400*msg.value)/10000000000);\n', '    \t        if(check >= 1900000000000000)\n', '                pre_ico(msg.sender,msg.value);\n', '    \t    }\n', '            else if (now>=ico_start && now<ico_end)\n', '            {\n', '                main_ico(msg.sender,msg.value);\n', '            }\n', '            \n', '        }\n', '       \n', '       function pre_ico(address sender, uint value)payable\n', '       {\n', '          counter = counter+1;\n', '\t      investor[counter]=sender;\n', '          weireceived[counter]=value;\n', '          optsSent[counter] = (400*value)/10000000000;\n', '          balances[owner]=balances[owner]-optsSent[counter];\n', '          balances[investor[counter]]+=optsSent[counter];\n', '          preico(counter,investor[counter],weireceived[counter],optsSent[counter]);\n', '       }\n', '       \n', '       function  main_ico(address sender, uint value)payable\n', '       {\n', '           if(now >= ico_start && now <= (ico_start + 7 days)) //20% discount on BOPT\n', '           {\n', '              counter = counter+1;\n', '    \t      investor[counter]=sender;\n', '              weireceived[counter]=value;\n', '              optsSent[counter] = (250*value)/10000000000;\n', '              balances[owner]=balances[owner]-optsSent[counter];\n', '              balances[investor[counter]]+=optsSent[counter];\n', '              ico(counter,investor[counter],weireceived[counter],optsSent[counter]);\n', '           }\n', '           else if (now >= (ico_start + 7 days) && now <= (ico_start + 14 days)) //10% discount on BOPT\n', '           {\n', '              counter = counter+1;\n', '    \t      investor[counter]=sender;\n', '              weireceived[counter]=value;\n', '              optsSent[counter] = (220*value)/10000000000;\n', '              balances[owner]=balances[owner]-optsSent[counter];\n', '              balances[investor[counter]]+=optsSent[counter];\n', '              ico(counter,investor[counter],weireceived[counter],optsSent[counter]);\n', '           }\n', '           else if (now >= (ico_start + 14 days) && now <= (ico_start + 31 days)) //no discount on BOPT\n', '           {\n', '              counter = counter+1;\n', '    \t      investor[counter]=sender;\n', '              weireceived[counter]=value;\n', '              optsSent[counter] = (200*value)/10000000000;\n', '              balances[owner]=balances[owner]-optsSent[counter];\n', '              balances[investor[counter]]+=optsSent[counter];\n', '              ico(counter,investor[counter],weireceived[counter],optsSent[counter]);\n', '           }\n', '       }\n', '       \n', '       function startICO()onlyOwner\n', '       {\n', '           ico_start = now;\n', '           ico_end=ico_start + 31 days;\n', '           pre_ico_start = 0;\n', '           pre_ico_end = 0;\n', '           \n', '       }\n', '       \n', '      \n', '        function endICO()onlyOwner\n', '       {\n', '          stopped=true;\n', '          if(balances[owner] > 150000000000000)\n', '          {\n', '              uint burnedTokens = balances[owner]-150000000000000;\n', '           totalSupply = totalSupply-burnedTokens;\n', '           balances[owner] = 150000000000000;\n', '          }\n', '       }\n', '}']
['pragma solidity ^ 0.4 .8;\n', '\n', '\n', 'contract ERC20 {\n', '\n', '    uint public totalSupply;\n', '\n', '    function balanceOf(address who) constant returns(uint256);\n', '\n', '    function allowance(address owner, address spender) constant returns(uint);\n', '\n', '    function transferFrom(address from, address to, uint value) returns(bool ok);\n', '\n', '    function approve(address spender, uint value) returns(bool ok);\n', '\n', '    function transfer(address to, uint value) returns(bool ok);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint value);\n', '\n', '    event Approval(address indexed owner, address indexed spender, uint value);\n', '\n', '}\n', '\n', 'contract blockoptions is ERC20\n', '\n', '{\n', '\n', '       /* Public variables of the token */\n', '      //To store name for token\n', '      string public name = "blockoptions";\n', '    \n', '      //To store symbol for token       \n', '      string public symbol = "BOPT";\n', '    \n', '      //To store decimal places for token\n', '      uint8 public decimals = 8;    \n', '    \n', '      //To store current supply of BOPT\n', '      uint public totalSupply=20000000 * 100000000;\n', '      \n', '       uint pre_ico_start;\n', '       uint pre_ico_end;\n', '       uint ico_start;\n', '       uint ico_end;\n', '       mapping(uint => address) investor;\n', '       mapping(uint => uint) weireceived;\n', '       mapping(uint => uint) optsSent;\n', '      \n', '        event preico(uint counter,address investors,uint weiReceived,uint boptsent);\n', '        event ico(uint counter,address investors,uint weiReceived,uint boptsent);\n', '        uint counter=0;\n', '        uint profit_sent=0;\n', '        bool stopped = false;\n', '        \n', '      function blockoptions() payable{\n', '          owner = msg.sender;\n', '          balances[owner] = totalSupply ; //to handle 8 decimal places\n', '          pre_ico_start = now;\n', '          pre_ico_end = pre_ico_start + 7 days;\n', '          \n', '        }\n', '      //map to store BOPT balance corresponding to address\n', '      mapping(address => uint) balances;\n', '    \n', "      //To store spender with allowed amount of BOPT to spend corresponding to BOPTs holder's account\n", '      mapping (address => mapping (address => uint)) allowed;\n', '    \n', '      //owner variable to store contract owner account\n', '      address public owner;\n', '      \n', '      //modifier to check transaction initiator is only owner\n', '      modifier onlyOwner() {\n', '        if (msg.sender == owner)\n', '          _;\n', '      }\n', '    \n', "      //ownership can be transferred to provided newOwner. Function can only be initiated by contract owner's account\n", '      function transferOwnership(address newOwner) onlyOwner {\n', '          balances[newOwner] = balances[owner];\n', '          balances[owner]=0;\n', '          owner = newOwner;\n', '      }\n', '\n', '        /**\n', '        * Multiplication with safety check\n', '        */\n', '        function Mul(uint a, uint b) internal returns (uint) {\n', '          uint c = a * b;\n', '          //check result should not be other wise until a=0\n', '          assert(a == 0 || c / a == b);\n', '          return c;\n', '        }\n', '    \n', '        /**\n', '        * Division with safety check\n', '        */\n', '        function Div(uint a, uint b) internal returns (uint) {\n', '          //overflow check; b must not be 0\n', '          assert(b > 0);\n', '          uint c = a / b;\n', '          assert(a == b * c + a % b);\n', '          return c;\n', '        }\n', '    \n', '        /**\n', '        * Subtraction with safety check\n', '        */\n', '        function Sub(uint a, uint b) internal returns (uint) {\n', '          //b must be greater that a as we need to store value in unsigned integer\n', '          assert(b <= a);\n', '          return a - b;\n', '        }\n', '    \n', '        /**\n', '        * Addition with safety check\n', '        */\n', '        function Add(uint a, uint b) internal returns (uint) {\n', '          uint c = a + b;\n', '          //result must be greater as a or b can not be negative\n', '          assert(c>=a && c>=b);\n', '          return c;\n', '        }\n', '    \n', '      /**\n', '        * assert used in different Math functions\n', '        */\n', '        function assert(bool assertion) internal {\n', '          if (!assertion) {\n', '            throw;\n', '          }\n', '        }\n', '    \n', '    //Implementation for transferring BOPT to provided address \n', '      function transfer(address _to, uint _value) returns (bool){\n', '\n', '        uint check = balances[owner] - _value;\n', '        if(msg.sender == owner && now>=pre_ico_start && now<=pre_ico_end && check < 1900000000000000)\n', '        {\n', '            return false;\n', '        }\n', '        else if(msg.sender ==owner && now>=pre_ico_end && now<=(pre_ico_end + 16 days) && check < 1850000000000000)\n', '        {\n', '            return false;\n', '        }\n', '        else if(msg.sender == owner && check < 150000000000000 && now < ico_start + 180 days)\n', '        {\n', '            return false;\n', '        }\n', '        else if (msg.sender == owner && check < 100000000000000 && now < ico_start + 360 days)\n', '        {\n', '            return false;\n', '        }\n', '        else if (msg.sender == owner && check < 50000000000000 && now < ico_start + 540 days)\n', '        {\n', '            return false;\n', '        }\n', '        //Check provided BOPT should not be 0\n', '       else if (_value > 0) {\n', '          //deduct OPTS amount from transaction initiator\n', '          balances[msg.sender] = Sub(balances[msg.sender],_value);\n', '          //Add OPTS to balace of target account\n', '          balances[_to] = Add(balances[_to],_value);\n', '          //Emit event for transferring BOPT\n', '          Transfer(msg.sender, _to, _value);\n', '          return true;\n', '        }\n', '        else{\n', '          return false;\n', '        }\n', '      }\n', '      \n', '      //Transfer initiated by spender \n', '      function transferFrom(address _from, address _to, uint _value) returns (bool) {\n', '    \n', '        //Check provided BOPT should not be 0\n', '        if (_value > 0) {\n', '          //Get amount of BOPT for which spender is authorized\n', '          var _allowance = allowed[_from][msg.sender];\n', "          //Add amount of BOPT in trarget account's balance\n", '          balances[_to] = Add(balances[_to], _value);\n', '          //Deduct BOPT amount from _from account\n', '          balances[_from] = Sub(balances[_from], _value);\n', '          //Deduct Authorized amount for spender\n', '          allowed[_from][msg.sender] = Sub(_allowance, _value);\n', '          //Emit event for Transfer\n', '          Transfer(_from, _to, _value);\n', '          return true;\n', '        }else{\n', '          return false;\n', '        }\n', '      }\n', '      \n', '      //Get BOPT balance for provided address\n', '      function balanceOf(address _owner) constant returns (uint balance) {\n', '        return balances[_owner];\n', '      }\n', '      \n', '      //Add spender to authorize for spending specified amount of BOPT \n', '      function approve(address _spender, uint _value) returns (bool) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        //Emit event for approval provided to spender\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '      }\n', '      \n', "      //Get BOPT amount that spender can spend from provided owner's account \n", '      function allowance(address _owner, address _spender) constant returns (uint remaining) {\n', '        return allowed[_owner][_spender];\n', '      }\n', '      \n', '       /*\t\n', '       * Failsafe drain\n', '       */\n', '    \tfunction drain() onlyOwner {\n', '    \t\towner.send(this.balance);\n', '    \t}\n', '\t\n', '    \tfunction() payable \n', '    \t{   \n', '    \t    if(stopped && msg.sender != owner)\n', '    \t    revert();\n', '    \t     else if(msg.sender == owner)\n', '    \t    {\n', '    \t        profit_sent = msg.value;\n', '    \t    }\n', '    \t   else if(now>=pre_ico_start && now<=pre_ico_end)\n', '    \t    {\n', '    \t        uint check = balances[owner]-((400*msg.value)/10000000000);\n', '    \t        if(check >= 1900000000000000)\n', '                pre_ico(msg.sender,msg.value);\n', '    \t    }\n', '            else if (now>=ico_start && now<ico_end)\n', '            {\n', '                main_ico(msg.sender,msg.value);\n', '            }\n', '            \n', '        }\n', '       \n', '       function pre_ico(address sender, uint value)payable\n', '       {\n', '          counter = counter+1;\n', '\t      investor[counter]=sender;\n', '          weireceived[counter]=value;\n', '          optsSent[counter] = (400*value)/10000000000;\n', '          balances[owner]=balances[owner]-optsSent[counter];\n', '          balances[investor[counter]]+=optsSent[counter];\n', '          preico(counter,investor[counter],weireceived[counter],optsSent[counter]);\n', '       }\n', '       \n', '       function  main_ico(address sender, uint value)payable\n', '       {\n', '           if(now >= ico_start && now <= (ico_start + 7 days)) //20% discount on BOPT\n', '           {\n', '              counter = counter+1;\n', '    \t      investor[counter]=sender;\n', '              weireceived[counter]=value;\n', '              optsSent[counter] = (250*value)/10000000000;\n', '              balances[owner]=balances[owner]-optsSent[counter];\n', '              balances[investor[counter]]+=optsSent[counter];\n', '              ico(counter,investor[counter],weireceived[counter],optsSent[counter]);\n', '           }\n', '           else if (now >= (ico_start + 7 days) && now <= (ico_start + 14 days)) //10% discount on BOPT\n', '           {\n', '              counter = counter+1;\n', '    \t      investor[counter]=sender;\n', '              weireceived[counter]=value;\n', '              optsSent[counter] = (220*value)/10000000000;\n', '              balances[owner]=balances[owner]-optsSent[counter];\n', '              balances[investor[counter]]+=optsSent[counter];\n', '              ico(counter,investor[counter],weireceived[counter],optsSent[counter]);\n', '           }\n', '           else if (now >= (ico_start + 14 days) && now <= (ico_start + 31 days)) //no discount on BOPT\n', '           {\n', '              counter = counter+1;\n', '    \t      investor[counter]=sender;\n', '              weireceived[counter]=value;\n', '              optsSent[counter] = (200*value)/10000000000;\n', '              balances[owner]=balances[owner]-optsSent[counter];\n', '              balances[investor[counter]]+=optsSent[counter];\n', '              ico(counter,investor[counter],weireceived[counter],optsSent[counter]);\n', '           }\n', '       }\n', '       \n', '       function startICO()onlyOwner\n', '       {\n', '           ico_start = now;\n', '           ico_end=ico_start + 31 days;\n', '           pre_ico_start = 0;\n', '           pre_ico_end = 0;\n', '           \n', '       }\n', '       \n', '      \n', '        function endICO()onlyOwner\n', '       {\n', '          stopped=true;\n', '          if(balances[owner] > 150000000000000)\n', '          {\n', '              uint burnedTokens = balances[owner]-150000000000000;\n', '           totalSupply = totalSupply-burnedTokens;\n', '           balances[owner] = 150000000000000;\n', '          }\n', '       }\n', '}']