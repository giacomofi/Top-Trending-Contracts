['pragma solidity ^0.4.13;\n', '    \n', '   // ----------------------------------------------------------------------------------------------\n', '   // Developer Nechesov Andrey: Facebook.com/Nechesov   \n', '   // Enjoy. (c) PRCR.org ICO Platform 2017. The PRCR Licence.\n', '   // ----------------------------------------------------------------------------------------------\n', '    \n', '   // ERC Token Standard #20 Interface\n', '   // https://github.com/ethereum/EIPs/issues/20\n', '  contract ERC20Interface {\n', '      // Get the total token supply\n', '      function totalSupply() constant returns (uint256 totalSupply);\n', '   \n', '      // Get the account balance of another account with address _owner\n', '      function balanceOf(address _owner) constant returns (uint256 balance);\n', '   \n', '      // Send _value amount of tokens to address _to\n', '      function transfer(address _to, uint256 _value) returns (bool success);\n', '   \n', '      // Send _value amount of tokens from address _from to address _to\n', '      function transferFrom(address _from, address _to, uint256 _value) returns (bool success);\n', '   \n', '      // Allow _spender to withdraw from your account, multiple times, up to the _value amount.\n', '      // If this function is called again it overwrites the current allowance with _value.\n', '      // this function is required for some DEX functionality\n', '      function approve(address _spender, uint256 _value) returns (bool success);\n', '   \n', '      // Returns the amount which _spender is still allowed to withdraw from _owner\n', '      function allowance(address _owner, address _spender) constant returns (uint256 remaining);\n', '   \n', '      // Triggered when tokens are transferred.\n', '      event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '   \n', '      // Triggered whenever approve(address _spender, uint256 _value) is called.\n', '      event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '  }  \n', '   \n', '  contract CentraToken is ERC20Interface {\n', '\n', '      string public constant symbol = "Centra";\n', '      string public constant name = "Centra token";\n', '      uint8 public constant decimals = 18; \n', '           \n', '      uint256 public constant maxTokens = 100000000*10**18; \n', '      uint256 public constant ownerSupply = maxTokens*32/100;\n', '      uint256 _totalSupply = ownerSupply;  \n', '\n', '      uint256 public constant token_price = 1/400*10**18; \n', '      uint public constant ico_start = 1501891200;\n', '      uint public constant ico_finish = 1507248000; \n', '      uint public constant minValuePre = 1/10*10**18; \n', '      uint public constant minValue = 1/10*10**18; \n', '      uint public constant maxValue = 3000*10**18;       \n', '\n', '      uint public constant card_gold_minamount  = 30*10**18;\n', '      uint public constant card_gold_first = 1000;\n', '      mapping(address => uint) cards_gold_check; \n', '      address[] public cards_gold;\n', '\n', '      uint public constant card_black_minamount = 100*10**18;\n', '      uint public constant card_black_first = 500;\n', '      mapping(address => uint) public cards_black_check; \n', '      address[] public cards_black;\n', '\n', '      uint public constant card_titanium_minamount  = 500*10**18;\n', '      uint public constant card_titanium_first = 200;\n', '      mapping(address => uint) cards_titanium_check; \n', '      address[] public cards_titanium;\n', '\n', '      uint public constant card_blue_minamount  = 5/10*10**18;\n', '      uint public constant card_blue_first = 100000000;\n', '      mapping(address => uint) cards_blue_check; \n', '      address[] public cards_blue;\n', '\n', '      uint public constant card_start_minamount  = 1/10*10**18;\n', '      uint public constant card_start_first = 100000000;\n', '      mapping(address => uint) cards_start_check; \n', '      address[] public cards_start;\n', '\n', '      using SafeMath for uint;      \n', '      \n', '      // Owner of this contract\n', '      address public owner;\n', '   \n', '      // Balances for each account\n', '      mapping(address => uint256) balances;\n', '   \n', '      // Owner of account approves the transfer of an amount to another account\n', '      mapping(address => mapping (address => uint256)) allowed;\n', '   \n', '      // Functions with this modifier can only be executed by the owner\n', '      modifier onlyOwner() {\n', '          if (msg.sender != owner) {\n', '              throw;\n', '          }\n', '          _;\n', '      }      \n', '   \n', '      // Constructor\n', '      function CentraToken() {\n', '          owner = msg.sender;\n', '          balances[owner] = ownerSupply;\n', '      }\n', '      \n', '      //default function for buy tokens      \n', '      function() payable {        \n', '          tokens_buy();        \n', '      }\n', '      \n', '      function totalSupply() constant returns (uint256 totalSupply) {\n', '          totalSupply = _totalSupply;\n', '      }\n', '\n', '      //Withdraw money from contract balance to owner\n', '      function withdraw() onlyOwner returns (bool result) {\n', '          owner.send(this.balance);\n', '          return true;\n', '      }\n', '   \n', '      // What is the balance of a particular account?\n', '      function balanceOf(address _owner) constant returns (uint256 balance) {\n', '          return balances[_owner];\n', '      }\n', '   \n', '      // Transfer the balance from owner&#39;s account to another account\n', '      function transfer(address _to, uint256 _amount) returns (bool success) {\n', '\n', '          if(now < ico_start) throw;\n', '\n', '          if (balances[msg.sender] >= _amount \n', '              && _amount > 0\n', '              && balances[_to] + _amount > balances[_to]) {\n', '              balances[msg.sender] -= _amount;\n', '              balances[_to] += _amount;\n', '              Transfer(msg.sender, _to, _amount);\n', '              return true;\n', '          } else {\n', '              return false;\n', '          }\n', '      }\n', '   \n', '      // Send _value amount of tokens from address _from to address _to\n', '      // The transferFrom method is used for a withdraw workflow, allowing contracts to send\n', '      // tokens on your behalf, for example to "deposit" to a contract address and/or to charge\n', '      // fees in sub-currencies; the command should fail unless the _from account has\n', '      // deliberately authorized the sender of the message via some mechanism; we propose\n', '      // these standardized APIs for approval:\n', '      function transferFrom(\n', '          address _from,\n', '          address _to,\n', '          uint256 _amount\n', '     ) returns (bool success) {\n', '\n', '         if(now < ico_start) throw;\n', '\n', '         if (balances[_from] >= _amount\n', '             && allowed[_from][msg.sender] >= _amount\n', '             && _amount > 0\n', '             && balances[_to] + _amount > balances[_to]) {\n', '             balances[_from] -= _amount;\n', '             allowed[_from][msg.sender] -= _amount;\n', '             balances[_to] += _amount;\n', '             Transfer(_from, _to, _amount);\n', '             return true;\n', '         } else {\n', '             return false;\n', '         }\n', '     }\n', '  \n', '     // Allow _spender to withdraw from your account, multiple times, up to the _value amount.\n', '     // If this function is called again it overwrites the current allowance with _value.\n', '     function approve(address _spender, uint256 _amount) returns (bool success) {\n', '         allowed[msg.sender][_spender] = _amount;\n', '         Approval(msg.sender, _spender, _amount);\n', '         return true;\n', '     }\n', '  \n', '     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {\n', '         return allowed[_owner][_spender];\n', '     }\n', '     //get total black cards\n', '    function cards_black_total() constant returns (uint) { \n', '      return cards_black.length;\n', '    }\n', '    //get total gold cards\n', '    function cards_gold_total() constant returns (uint) { \n', '      return cards_gold.length;\n', '    }    \n', '    //get total titanium cards\n', '    function cards_titanium_total() constant returns (uint) { \n', '      return cards_titanium.length;\n', '    }\n', '    //get total blue cards\n', '    function cards_blue_total() constant returns (uint) { \n', '      return cards_blue.length;\n', '    }\n', '\n', '    //get total start cards\n', '    function cards_start_total() constant returns (uint) { \n', '      return cards_start.length;\n', '    }\n', '\n', '      /**\n', '      * Buy tokens pre-sale and sale \n', '      */\n', '      function tokens_buy() payable returns (bool) { \n', '\n', '        uint tnow = now;\n', '        \n', '        if(tnow > ico_finish) throw;        \n', '        if(_totalSupply >= maxTokens) throw;\n', '        if(!(msg.value >= token_price)) throw;\n', '        if(!(msg.value >= minValue)) throw;\n', '        if(msg.value > maxValue) throw;\n', '\n', '        uint tokens_buy = msg.value/token_price*10**18;\n', '\n', '        if(!(tokens_buy > 0)) throw;   \n', '\n', '        if(tnow < ico_start){\n', '          if(!(msg.value >= minValuePre)) throw;\n', '          tokens_buy = tokens_buy*125/100;\n', '        } \n', '        if((ico_start + 86400*0 <= tnow)&&(tnow < ico_start + 86400*2)){\n', '          tokens_buy = tokens_buy*120/100;\n', '        } \n', '        if((ico_start + 86400*2 <= tnow)&&(tnow < ico_start + 86400*7)){\n', '          tokens_buy = tokens_buy*110/100;        \n', '        } \n', '        if((ico_start + 86400*7 <= tnow)&&(tnow < ico_start + 86400*14)){\n', '          tokens_buy = tokens_buy*105/100;        \n', '        }         \n', '\n', '        if(_totalSupply.add(tokens_buy) > maxTokens) throw;\n', '        _totalSupply = _totalSupply.add(tokens_buy);\n', '        balances[msg.sender] = balances[msg.sender].add(tokens_buy); \n', '\n', '        if((msg.value >= card_gold_minamount)\n', '          &&(msg.value < card_black_minamount)\n', '          &&(cards_gold.length < card_gold_first)\n', '          &&(cards_gold_check[msg.sender] != 1)\n', '          ) {\n', '          cards_gold.push(msg.sender);\n', '          cards_gold_check[msg.sender] = 1;\n', '        }       \n', '\n', '        if((msg.value >= card_black_minamount)\n', '          &&(msg.value < card_titanium_minamount)\n', '          &&(cards_black.length < card_black_first)\n', '          &&(cards_black_check[msg.sender] != 1)\n', '          ) {\n', '          cards_black.push(msg.sender);\n', '          cards_black_check[msg.sender] = 1;\n', '        }        \n', '\n', '        if((msg.value >= card_titanium_minamount)\n', '          &&(cards_titanium.length < card_titanium_first)\n', '          &&(cards_titanium_check[msg.sender] != 1)\n', '          ) {\n', '          cards_titanium.push(msg.sender);\n', '          cards_titanium_check[msg.sender] = 1;\n', '        }\n', '\n', '        if((msg.value >= card_blue_minamount)\n', '          &&(msg.value < card_gold_minamount)\n', '          &&(cards_blue.length < card_blue_first)\n', '          &&(cards_blue_check[msg.sender] != 1)\n', '          ) {\n', '          cards_blue.push(msg.sender);\n', '          cards_blue_check[msg.sender] = 1;\n', '        }\n', '\n', '        if((msg.value >= card_start_minamount)\n', '          &&(msg.value < card_blue_minamount)\n', '          &&(cards_start.length < card_start_first)\n', '          &&(cards_start_check[msg.sender] != 1)\n', '          ) {\n', '          cards_start.push(msg.sender);\n', '          cards_start_check[msg.sender] = 1;\n', '        }\n', '\n', '        return true;\n', '      }\n', '      \n', ' }\n', '\n', ' /**\n', '   * Math operations with safety checks\n', '   */\n', '  library SafeMath {\n', '    function mul(uint a, uint b) internal returns (uint) {\n', '      uint c = a * b;\n', '      assert(a == 0 || c / a == b);\n', '      return c;\n', '    }\n', '\n', '    function div(uint a, uint b) internal returns (uint) {\n', '      // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '      uint c = a / b;\n', '      // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '      return c;\n', '    }\n', '\n', '    function sub(uint a, uint b) internal returns (uint) {\n', '      assert(b <= a);\n', '      return a - b;\n', '    }\n', '\n', '    function add(uint a, uint b) internal returns (uint) {\n', '      uint c = a + b;\n', '      assert(c >= a);\n', '      return c;\n', '    }\n', '\n', '    function max64(uint64 a, uint64 b) internal constant returns (uint64) {\n', '      return a >= b ? a : b;\n', '    }\n', '\n', '    function min64(uint64 a, uint64 b) internal constant returns (uint64) {\n', '      return a < b ? a : b;\n', '    }\n', '\n', '    function max256(uint256 a, uint256 b) internal constant returns (uint256) {\n', '      return a >= b ? a : b;\n', '    }\n', '\n', '    function min256(uint256 a, uint256 b) internal constant returns (uint256) {\n', '      return a < b ? a : b;\n', '    }\n', '\n', '    function assert(bool assertion) internal {\n', '      if (!assertion) {\n', '        throw;\n', '      }\n', '    }\n', '  }']
['pragma solidity ^0.4.13;\n', '    \n', '   // ----------------------------------------------------------------------------------------------\n', '   // Developer Nechesov Andrey: Facebook.com/Nechesov   \n', '   // Enjoy. (c) PRCR.org ICO Platform 2017. The PRCR Licence.\n', '   // ----------------------------------------------------------------------------------------------\n', '    \n', '   // ERC Token Standard #20 Interface\n', '   // https://github.com/ethereum/EIPs/issues/20\n', '  contract ERC20Interface {\n', '      // Get the total token supply\n', '      function totalSupply() constant returns (uint256 totalSupply);\n', '   \n', '      // Get the account balance of another account with address _owner\n', '      function balanceOf(address _owner) constant returns (uint256 balance);\n', '   \n', '      // Send _value amount of tokens to address _to\n', '      function transfer(address _to, uint256 _value) returns (bool success);\n', '   \n', '      // Send _value amount of tokens from address _from to address _to\n', '      function transferFrom(address _from, address _to, uint256 _value) returns (bool success);\n', '   \n', '      // Allow _spender to withdraw from your account, multiple times, up to the _value amount.\n', '      // If this function is called again it overwrites the current allowance with _value.\n', '      // this function is required for some DEX functionality\n', '      function approve(address _spender, uint256 _value) returns (bool success);\n', '   \n', '      // Returns the amount which _spender is still allowed to withdraw from _owner\n', '      function allowance(address _owner, address _spender) constant returns (uint256 remaining);\n', '   \n', '      // Triggered when tokens are transferred.\n', '      event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '   \n', '      // Triggered whenever approve(address _spender, uint256 _value) is called.\n', '      event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '  }  \n', '   \n', '  contract CentraToken is ERC20Interface {\n', '\n', '      string public constant symbol = "Centra";\n', '      string public constant name = "Centra token";\n', '      uint8 public constant decimals = 18; \n', '           \n', '      uint256 public constant maxTokens = 100000000*10**18; \n', '      uint256 public constant ownerSupply = maxTokens*32/100;\n', '      uint256 _totalSupply = ownerSupply;  \n', '\n', '      uint256 public constant token_price = 1/400*10**18; \n', '      uint public constant ico_start = 1501891200;\n', '      uint public constant ico_finish = 1507248000; \n', '      uint public constant minValuePre = 1/10*10**18; \n', '      uint public constant minValue = 1/10*10**18; \n', '      uint public constant maxValue = 3000*10**18;       \n', '\n', '      uint public constant card_gold_minamount  = 30*10**18;\n', '      uint public constant card_gold_first = 1000;\n', '      mapping(address => uint) cards_gold_check; \n', '      address[] public cards_gold;\n', '\n', '      uint public constant card_black_minamount = 100*10**18;\n', '      uint public constant card_black_first = 500;\n', '      mapping(address => uint) public cards_black_check; \n', '      address[] public cards_black;\n', '\n', '      uint public constant card_titanium_minamount  = 500*10**18;\n', '      uint public constant card_titanium_first = 200;\n', '      mapping(address => uint) cards_titanium_check; \n', '      address[] public cards_titanium;\n', '\n', '      uint public constant card_blue_minamount  = 5/10*10**18;\n', '      uint public constant card_blue_first = 100000000;\n', '      mapping(address => uint) cards_blue_check; \n', '      address[] public cards_blue;\n', '\n', '      uint public constant card_start_minamount  = 1/10*10**18;\n', '      uint public constant card_start_first = 100000000;\n', '      mapping(address => uint) cards_start_check; \n', '      address[] public cards_start;\n', '\n', '      using SafeMath for uint;      \n', '      \n', '      // Owner of this contract\n', '      address public owner;\n', '   \n', '      // Balances for each account\n', '      mapping(address => uint256) balances;\n', '   \n', '      // Owner of account approves the transfer of an amount to another account\n', '      mapping(address => mapping (address => uint256)) allowed;\n', '   \n', '      // Functions with this modifier can only be executed by the owner\n', '      modifier onlyOwner() {\n', '          if (msg.sender != owner) {\n', '              throw;\n', '          }\n', '          _;\n', '      }      \n', '   \n', '      // Constructor\n', '      function CentraToken() {\n', '          owner = msg.sender;\n', '          balances[owner] = ownerSupply;\n', '      }\n', '      \n', '      //default function for buy tokens      \n', '      function() payable {        \n', '          tokens_buy();        \n', '      }\n', '      \n', '      function totalSupply() constant returns (uint256 totalSupply) {\n', '          totalSupply = _totalSupply;\n', '      }\n', '\n', '      //Withdraw money from contract balance to owner\n', '      function withdraw() onlyOwner returns (bool result) {\n', '          owner.send(this.balance);\n', '          return true;\n', '      }\n', '   \n', '      // What is the balance of a particular account?\n', '      function balanceOf(address _owner) constant returns (uint256 balance) {\n', '          return balances[_owner];\n', '      }\n', '   \n', "      // Transfer the balance from owner's account to another account\n", '      function transfer(address _to, uint256 _amount) returns (bool success) {\n', '\n', '          if(now < ico_start) throw;\n', '\n', '          if (balances[msg.sender] >= _amount \n', '              && _amount > 0\n', '              && balances[_to] + _amount > balances[_to]) {\n', '              balances[msg.sender] -= _amount;\n', '              balances[_to] += _amount;\n', '              Transfer(msg.sender, _to, _amount);\n', '              return true;\n', '          } else {\n', '              return false;\n', '          }\n', '      }\n', '   \n', '      // Send _value amount of tokens from address _from to address _to\n', '      // The transferFrom method is used for a withdraw workflow, allowing contracts to send\n', '      // tokens on your behalf, for example to "deposit" to a contract address and/or to charge\n', '      // fees in sub-currencies; the command should fail unless the _from account has\n', '      // deliberately authorized the sender of the message via some mechanism; we propose\n', '      // these standardized APIs for approval:\n', '      function transferFrom(\n', '          address _from,\n', '          address _to,\n', '          uint256 _amount\n', '     ) returns (bool success) {\n', '\n', '         if(now < ico_start) throw;\n', '\n', '         if (balances[_from] >= _amount\n', '             && allowed[_from][msg.sender] >= _amount\n', '             && _amount > 0\n', '             && balances[_to] + _amount > balances[_to]) {\n', '             balances[_from] -= _amount;\n', '             allowed[_from][msg.sender] -= _amount;\n', '             balances[_to] += _amount;\n', '             Transfer(_from, _to, _amount);\n', '             return true;\n', '         } else {\n', '             return false;\n', '         }\n', '     }\n', '  \n', '     // Allow _spender to withdraw from your account, multiple times, up to the _value amount.\n', '     // If this function is called again it overwrites the current allowance with _value.\n', '     function approve(address _spender, uint256 _amount) returns (bool success) {\n', '         allowed[msg.sender][_spender] = _amount;\n', '         Approval(msg.sender, _spender, _amount);\n', '         return true;\n', '     }\n', '  \n', '     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {\n', '         return allowed[_owner][_spender];\n', '     }\n', '     //get total black cards\n', '    function cards_black_total() constant returns (uint) { \n', '      return cards_black.length;\n', '    }\n', '    //get total gold cards\n', '    function cards_gold_total() constant returns (uint) { \n', '      return cards_gold.length;\n', '    }    \n', '    //get total titanium cards\n', '    function cards_titanium_total() constant returns (uint) { \n', '      return cards_titanium.length;\n', '    }\n', '    //get total blue cards\n', '    function cards_blue_total() constant returns (uint) { \n', '      return cards_blue.length;\n', '    }\n', '\n', '    //get total start cards\n', '    function cards_start_total() constant returns (uint) { \n', '      return cards_start.length;\n', '    }\n', '\n', '      /**\n', '      * Buy tokens pre-sale and sale \n', '      */\n', '      function tokens_buy() payable returns (bool) { \n', '\n', '        uint tnow = now;\n', '        \n', '        if(tnow > ico_finish) throw;        \n', '        if(_totalSupply >= maxTokens) throw;\n', '        if(!(msg.value >= token_price)) throw;\n', '        if(!(msg.value >= minValue)) throw;\n', '        if(msg.value > maxValue) throw;\n', '\n', '        uint tokens_buy = msg.value/token_price*10**18;\n', '\n', '        if(!(tokens_buy > 0)) throw;   \n', '\n', '        if(tnow < ico_start){\n', '          if(!(msg.value >= minValuePre)) throw;\n', '          tokens_buy = tokens_buy*125/100;\n', '        } \n', '        if((ico_start + 86400*0 <= tnow)&&(tnow < ico_start + 86400*2)){\n', '          tokens_buy = tokens_buy*120/100;\n', '        } \n', '        if((ico_start + 86400*2 <= tnow)&&(tnow < ico_start + 86400*7)){\n', '          tokens_buy = tokens_buy*110/100;        \n', '        } \n', '        if((ico_start + 86400*7 <= tnow)&&(tnow < ico_start + 86400*14)){\n', '          tokens_buy = tokens_buy*105/100;        \n', '        }         \n', '\n', '        if(_totalSupply.add(tokens_buy) > maxTokens) throw;\n', '        _totalSupply = _totalSupply.add(tokens_buy);\n', '        balances[msg.sender] = balances[msg.sender].add(tokens_buy); \n', '\n', '        if((msg.value >= card_gold_minamount)\n', '          &&(msg.value < card_black_minamount)\n', '          &&(cards_gold.length < card_gold_first)\n', '          &&(cards_gold_check[msg.sender] != 1)\n', '          ) {\n', '          cards_gold.push(msg.sender);\n', '          cards_gold_check[msg.sender] = 1;\n', '        }       \n', '\n', '        if((msg.value >= card_black_minamount)\n', '          &&(msg.value < card_titanium_minamount)\n', '          &&(cards_black.length < card_black_first)\n', '          &&(cards_black_check[msg.sender] != 1)\n', '          ) {\n', '          cards_black.push(msg.sender);\n', '          cards_black_check[msg.sender] = 1;\n', '        }        \n', '\n', '        if((msg.value >= card_titanium_minamount)\n', '          &&(cards_titanium.length < card_titanium_first)\n', '          &&(cards_titanium_check[msg.sender] != 1)\n', '          ) {\n', '          cards_titanium.push(msg.sender);\n', '          cards_titanium_check[msg.sender] = 1;\n', '        }\n', '\n', '        if((msg.value >= card_blue_minamount)\n', '          &&(msg.value < card_gold_minamount)\n', '          &&(cards_blue.length < card_blue_first)\n', '          &&(cards_blue_check[msg.sender] != 1)\n', '          ) {\n', '          cards_blue.push(msg.sender);\n', '          cards_blue_check[msg.sender] = 1;\n', '        }\n', '\n', '        if((msg.value >= card_start_minamount)\n', '          &&(msg.value < card_blue_minamount)\n', '          &&(cards_start.length < card_start_first)\n', '          &&(cards_start_check[msg.sender] != 1)\n', '          ) {\n', '          cards_start.push(msg.sender);\n', '          cards_start_check[msg.sender] = 1;\n', '        }\n', '\n', '        return true;\n', '      }\n', '      \n', ' }\n', '\n', ' /**\n', '   * Math operations with safety checks\n', '   */\n', '  library SafeMath {\n', '    function mul(uint a, uint b) internal returns (uint) {\n', '      uint c = a * b;\n', '      assert(a == 0 || c / a == b);\n', '      return c;\n', '    }\n', '\n', '    function div(uint a, uint b) internal returns (uint) {\n', '      // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '      uint c = a / b;\n', "      // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '      return c;\n', '    }\n', '\n', '    function sub(uint a, uint b) internal returns (uint) {\n', '      assert(b <= a);\n', '      return a - b;\n', '    }\n', '\n', '    function add(uint a, uint b) internal returns (uint) {\n', '      uint c = a + b;\n', '      assert(c >= a);\n', '      return c;\n', '    }\n', '\n', '    function max64(uint64 a, uint64 b) internal constant returns (uint64) {\n', '      return a >= b ? a : b;\n', '    }\n', '\n', '    function min64(uint64 a, uint64 b) internal constant returns (uint64) {\n', '      return a < b ? a : b;\n', '    }\n', '\n', '    function max256(uint256 a, uint256 b) internal constant returns (uint256) {\n', '      return a >= b ? a : b;\n', '    }\n', '\n', '    function min256(uint256 a, uint256 b) internal constant returns (uint256) {\n', '      return a < b ? a : b;\n', '    }\n', '\n', '    function assert(bool assertion) internal {\n', '      if (!assertion) {\n', '        throw;\n', '      }\n', '    }\n', '  }']
