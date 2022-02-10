['pragma solidity ^0.4.4;\n', '\n', '// ------------------------------------------------------------------------\n', '// TokenSellerFactory\n', '//\n', '// Decentralised trustless ERC20-partially-compliant token to ETH exchange\n', '// contract on the Ethereum blockchain.\n', '//\n', '// This caters for the Golem Network Token which does not implement the\n', '// ERC20 transferFrom(...), approve(...) and allowance(...) methods\n', '//\n', '// History:\n', '//   Jan 25 2017 - BPB Added makerTransferAsset(...)\n', '//   Feb 05 2017 - BPB Bug fix in the change calculation for the Unicorn\n', '//                     token with natural number 1\n', '//\n', '// Enjoy. (c) JonnyLatte, Cintix & BokkyPooBah 2017. The MIT licence.\n', '// ------------------------------------------------------------------------\n', '\n', '// https://github.com/ethereum/EIPs/issues/20\n', 'contract ERC20Partial {\n', '    function totalSupply() constant returns (uint totalSupply);\n', '    function balanceOf(address _owner) constant returns (uint balance);\n', '    function transfer(address _to, uint _value) returns (bool success);\n', '    // function transferFrom(address _from, address _to, uint _value) returns (bool success);\n', '    // function approve(address _spender, uint _value) returns (bool success);\n', '    // function allowance(address _owner, address _spender) constant returns (uint remaining);\n', '    event Transfer(address indexed _from, address indexed _to, uint _value);\n', '    // event Approval(address indexed _owner, address indexed _spender, uint _value);\n', '}\n', '\n', 'contract Owned {\n', '    address public owner;\n', '    event OwnershipTransferred(address indexed _from, address indexed _to);\n', '\n', '    function Owned() {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        if (msg.sender != owner) throw;\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address newOwner) onlyOwner {\n', '        OwnershipTransferred(owner, newOwner);\n', '        owner = newOwner;\n', '    }\n', '}\n', '\n', '// contract can sell tokens for ETH\n', '// prices are in amount of wei per batch of token units\n', '\n', 'contract TokenSeller is Owned {\n', '\n', '    address public asset;       // address of token\n', '    uint256 public sellPrice;   // contract sells lots of tokens at this price\n', '    uint256 public units;       // lot size (token-wei)\n', '\n', '    bool public sellsTokens;    // is contract selling\n', '\n', '    event ActivatedEvent(bool sells);\n', '    event MakerWithdrewAsset(uint256 tokens);\n', '    event MakerTransferredAsset(address toTokenSeller, uint256 tokens);\n', '    event MakerWithdrewERC20Token(address tokenAddress, uint256 tokens);\n', '    event MakerWithdrewEther(uint256 ethers);\n', '    event TakerBoughtAsset(address indexed buyer, uint256 ethersSent,\n', '        uint256 ethersReturned, uint256 tokensBought);\n', '\n', '    // Constructor - only to be called by the TokenSellerFactory contract\n', '    function TokenSeller (\n', '        address _asset,\n', '        uint256 _sellPrice,\n', '        uint256 _units,\n', '        bool    _sellsTokens\n', '    ) {\n', '        asset       = _asset;\n', '        sellPrice   = _sellPrice;\n', '        units       = _units;\n', '        sellsTokens = _sellsTokens;\n', '        ActivatedEvent(sellsTokens);\n', '    }\n', '\n', '    // Maker can activate or deactivate this contract&#39;s\n', '    // selling status\n', '    //\n', '    // The ActivatedEvent() event is logged with the following\n', '    // parameter:\n', '    //   sellsTokens  this contract can sell asset tokens\n', '    function activate (\n', '        bool _sellsTokens\n', '    ) onlyOwner {\n', '        sellsTokens = _sellsTokens;\n', '        ActivatedEvent(sellsTokens);\n', '    }\n', '\n', '    // Maker can withdraw asset tokens from this contract, with the\n', '    // following parameter:\n', '    //   tokens  is the number of asset tokens to be withdrawn\n', '    //\n', '    // The MakerWithdrewAsset() event is logged with the following\n', '    // parameter:\n', '    //   tokens  is the number of tokens withdrawn by the maker\n', '    //\n', '    // This method was called withdrawAsset() in the old version\n', '    function makerWithdrawAsset(uint256 tokens) onlyOwner returns (bool ok) {\n', '        MakerWithdrewAsset(tokens);\n', '        return ERC20Partial(asset).transfer(owner, tokens);\n', '    }\n', '\n', '    // Maker can transfer asset tokens from this contract to another\n', '    // TokenSeller contract, with the following parameter:\n', '    //   toTokenSeller  Another TokenSeller contract owned by the\n', '    //                  same owner\n', '    //   tokens         is the number of asset tokens to be moved\n', '    //\n', '    // The MakerTransferredAsset() event is logged with the following\n', '    // parameters:\n', '    //   toTokenSeller  The other TokenSeller contract owned by\n', '    //                  the same owner\n', '    //   tokens         is the number of tokens transferred\n', '    //\n', '    // The asset Transfer() event is logged from this contract to\n', '    // the other contract\n', '    //\n', '    function makerTransferAsset(\n', '        TokenSeller toTokenSeller,\n', '        uint256 tokens\n', '    ) onlyOwner returns (bool ok) {\n', '        if (owner != toTokenSeller.owner() || asset != toTokenSeller.asset()) {\n', '            throw;\n', '        }\n', '        MakerTransferredAsset(toTokenSeller, tokens);\n', '        return ERC20Partial(asset).transfer(toTokenSeller, tokens);\n', '    }\n', '\n', '    // Maker can withdraw any ERC20 asset tokens from this contract\n', '    //\n', '    // This method is included in the case where this contract receives\n', '    // the wrong tokens\n', '    //\n', '    // The MakerWithdrewERC20Token() event is logged with the following\n', '    // parameter:\n', '    //   tokenAddress  is the address of the tokens withdrawn by the maker\n', '    //   tokens        is the number of tokens withdrawn by the maker\n', '    //\n', '    // This method was called withdrawToken() in the old version\n', '    function makerWithdrawERC20Token(\n', '        address tokenAddress,\n', '        uint256 tokens\n', '    ) onlyOwner returns (bool ok) {\n', '        MakerWithdrewERC20Token(tokenAddress, tokens);\n', '        return ERC20Partial(tokenAddress).transfer(owner, tokens);\n', '    }\n', '\n', '    // Maker withdraws ethers from this contract\n', '    //\n', '    // The MakerWithdrewEther() event is logged with the following parameter\n', '    //   ethers  is the number of ethers withdrawn by the maker\n', '    //\n', '    // This method was called withdraw() in the old version\n', '    function makerWithdrawEther(uint256 ethers) onlyOwner returns (bool ok) {\n', '        if (this.balance >= ethers) {\n', '            MakerWithdrewEther(ethers);\n', '            return owner.send(ethers);\n', '        }\n', '    }\n', '\n', '    // Taker buys asset tokens by sending ethers\n', '    //\n', '    // The TakerBoughtAsset() event is logged with the following parameters\n', '    //   buyer           is the buyer&#39;s address\n', '    //   ethersSent      is the number of ethers sent by the buyer\n', '    //   ethersReturned  is the number of ethers sent back to the buyer as\n', '    //                   change\n', '    //   tokensBought    is the number of asset tokens sent to the buyer\n', '    //\n', '    // This method was called buy() in the old version\n', '    function takerBuyAsset() payable {\n', '        if (sellsTokens || msg.sender == owner) {\n', '            // Note that sellPrice has already been validated as > 0\n', '            uint order    = msg.value / sellPrice;\n', '            // Note that units has already been validated as > 0\n', '            uint can_sell = ERC20Partial(asset).balanceOf(address(this)) / units;\n', '            uint256 change = 0;\n', '            if (msg.value > (can_sell * sellPrice)) {\n', '                change  = msg.value - (can_sell * sellPrice);\n', '                order = can_sell;\n', '            }\n', '            if (change > 0) {\n', '                if (!msg.sender.send(change)) throw;\n', '            }\n', '            if (order > 0) {\n', '                if (!ERC20Partial(asset).transfer(msg.sender, order * units)) throw;\n', '            }\n', '            TakerBoughtAsset(msg.sender, msg.value, change, order * units);\n', '        }\n', '        // Return user funds if the contract is not selling\n', '        else if (!msg.sender.send(msg.value)) throw;\n', '    }\n', '\n', '    // Taker buys tokens by sending ethers\n', '    function () payable {\n', '        takerBuyAsset();\n', '    }\n', '}\n', '\n', '// This contract deploys TokenSeller contracts and logs the event\n', 'contract TokenSellerFactory is Owned {\n', '\n', '    event TradeListing(address indexed ownerAddress, address indexed tokenSellerAddress,\n', '        address indexed asset, uint256 sellPrice, uint256 units, bool sellsTokens);\n', '    event OwnerWithdrewERC20Token(address indexed tokenAddress, uint256 tokens);\n', '\n', '    mapping(address => bool) _verify;\n', '\n', '    // Anyone can call this method to verify the settings of a\n', '    // TokenSeller contract. The parameters are:\n', '    //   tradeContract  is the address of a TokenSeller contract\n', '    //\n', '    // Return values:\n', '    //   valid        did this TokenTraderFactory create the TokenTrader contract?\n', '    //   owner        is the owner of the TokenTrader contract\n', '    //   asset        is the ERC20 asset address\n', '    //   sellPrice    is the sell price in ethers per `units` of asset tokens\n', '    //   units        is the number of units of asset tokens\n', '    //   sellsTokens  is the TokenTrader contract selling tokens?\n', '    //\n', '    function verify(address tradeContract) constant returns (\n', '        bool    valid,\n', '        address owner,\n', '        address asset,\n', '        uint256 sellPrice,\n', '        uint256 units,\n', '        bool    sellsTokens\n', '    ) {\n', '        valid = _verify[tradeContract];\n', '        if (valid) {\n', '            TokenSeller t = TokenSeller(tradeContract);\n', '            owner         = t.owner();\n', '            asset         = t.asset();\n', '            sellPrice     = t.sellPrice();\n', '            units         = t.units();\n', '            sellsTokens   = t.sellsTokens();\n', '        }\n', '    }\n', '\n', '    // Maker can call this method to create a new TokenSeller contract\n', '    // with the maker being the owner of this new contract\n', '    //\n', '    // Parameters:\n', '    //   asset        is the ERC20 asset address\n', '    //   sellPrice    is the sell price in ethers per `units` of asset tokens\n', '    //   units        is the number of units of asset tokens\n', '    //   sellsTokens  is the TokenSeller contract selling tokens?\n', '    //\n', '    // For example, listing a TokenSeller contract on the GNT Golem Network Token\n', '    // where the contract will sell GNT tokens at a rate of 170/100000 = 0.0017 ETH\n', '    // per GNT token:\n', '    //   asset        0xa74476443119a942de498590fe1f2454d7d4ac0d\n', '    //   sellPrice    170\n', '    //   units        100000\n', '    //   sellsTokens  true\n', '    //\n', '    // The TradeListing() event is logged with the following parameters\n', '    //   ownerAddress        is the Maker&#39;s address\n', '    //   tokenSellerAddress  is the address of the newly created TokenSeller contract\n', '    //   asset               is the ERC20 asset address\n', '    //   sellPrice           is the sell price in ethers per `units` of asset tokens\n', '    //   unit                is the number of units of asset tokens\n', '    //   sellsTokens         is the TokenSeller contract selling tokens?\n', '    //\n', '    // This method was called createTradeContract() in the old version\n', '    //\n', '    function createSaleContract(\n', '        address asset,\n', '        uint256 sellPrice,\n', '        uint256 units,\n', '        bool    sellsTokens\n', '    ) returns (address seller) {\n', '        // Cannot have invalid asset\n', '        if (asset == 0x0) throw;\n', '        // Cannot set zero or negative price\n', '        if (sellPrice <= 0) throw;\n', '        // Cannot sell zero or negative units\n', '        if (units <= 0) throw;\n', '        seller = new TokenSeller(\n', '            asset,\n', '            sellPrice,\n', '            units,\n', '            sellsTokens);\n', '        // Record that this factory created the trader\n', '        _verify[seller] = true;\n', '        // Set the owner to whoever called the function\n', '        TokenSeller(seller).transferOwnership(msg.sender);\n', '        TradeListing(msg.sender, seller, asset, sellPrice, units, sellsTokens);\n', '    }\n', '\n', '    // Factory owner can withdraw any ERC20 asset tokens from this contract\n', '    //\n', '    // This method is included in the case where this contract receives\n', '    // the wrong tokens\n', '    //\n', '    // The OwnerWithdrewERC20Token() event is logged with the following\n', '    // parameter:\n', '    //   tokenAddress  is the address of the tokens withdrawn by the maker\n', '    //   tokens        is the number of tokens withdrawn by the maker\n', '    function ownerWithdrawERC20Token(address tokenAddress, uint256 tokens) onlyOwner returns (bool ok) {\n', '        OwnerWithdrewERC20Token(tokenAddress, tokens);\n', '        return ERC20Partial(tokenAddress).transfer(owner, tokens);\n', '    }\n', '\n', '    // Prevents accidental sending of ether to the factory\n', '    function () {\n', '        throw;\n', '    }\n', '}']