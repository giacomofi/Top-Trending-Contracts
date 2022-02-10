['pragma solidity ^0.4.11;\n', '\n', 'contract SandwichShop\n', '{\n', '    address owner;\n', '\n', '    modifier onlyOwner()\n', '    {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    struct Sandwich\n', '    {\n', '        uint sandwichID;\n', '        string sandwichName;\n', '        string sandwichDesc;\n', '        string calories;\n', '        uint price;\n', '        uint quantity;\n', '    }\n', '\n', '    struct OrderedSandwich\n', '    {\n', '        uint sandwichIdNumber;\n', '        string notes;\n', '        uint price;\n', '    }\n', '    \n', '    event NewSandwichTicket( string name, address customer, string sandName, string sandChanges );\n', '\n', '    Sandwich[5] shopSandwich;\n', '    mapping( address => OrderedSandwich[] ) public cart;\n', '    mapping( address => uint ) public subtotal;\n', '\n', '    function SandwichShop() public\n', '    {\n', '        owner = msg.sender;\n', '\n', '        shopSandwich[0].sandwichID = 0;\n', '        shopSandwich[0].sandwichName = "00:  Ham & Swiss";\n', '        shopSandwich[0].sandwichDesc = "Ham Swiss Mustard Rye";\n', '        shopSandwich[0].calories = "450 calories";\n', '        shopSandwich[0].price = 40 finney;\n', '        shopSandwich[0].quantity = 200;\n', '\n', '        shopSandwich[1].sandwichID = 1;\n', '        shopSandwich[1].sandwichName = "01:  Turkey & Pepperjack";\n', '        shopSandwich[1].sandwichDesc = "Turkey Pepperjack Mayo White Bread";\n', '        shopSandwich[1].calories = "500 calories";\n', '        shopSandwich[1].price = 45 finney;\n', '        shopSandwich[1].quantity = 200;\n', '\n', '        shopSandwich[2].sandwichID = 2;\n', '        shopSandwich[2].sandwichName = "02:  Roast Beef & American";\n', '        shopSandwich[2].sandwichDesc = "Roast Beef Havarti Horseradish White Bread";\n', '        shopSandwich[2].calories = "600 calories";\n', '        shopSandwich[2].price = 50 finney;\n', '        shopSandwich[2].quantity = 200;\n', '\n', '        shopSandwich[3].sandwichID = 3;\n', '        shopSandwich[3].sandwichName = "03:  Reuben";\n', '        shopSandwich[3].sandwichDesc = "Corned Beef Sauerkraut Swiss Rye";\n', '        shopSandwich[3].calories = "550 calories";\n', '        shopSandwich[3].price = 50 finney;\n', '        shopSandwich[3].quantity = 200;\n', '\n', '        shopSandwich[4].sandwichID = 4;\n', '        shopSandwich[4].sandwichName = "04:  Italian";\n', '        shopSandwich[4].sandwichDesc = "Salami Peppers Provolone Oil Vinegar White";\n', '        shopSandwich[4].calories = "500 calories";\n', '        shopSandwich[4].price = 40 finney;\n', '        shopSandwich[4].quantity = 200;\n', '    }\n', '\n', '    function getMenu() constant returns (string, string, string, string, string)\n', '    {\n', '        return (shopSandwich[0].sandwichName, shopSandwich[1].sandwichName,\n', '                shopSandwich[2].sandwichName, shopSandwich[3].sandwichName,\n', '                shopSandwich[4].sandwichName );\n', '    }\n', '\n', '    function getSandwichInfo(uint _sandwichId) constant returns (string, string, string, uint, uint)\n', '    {\n', '        if( _sandwichId > 4 )\n', '        {\n', '            return ( "wrong ID", "wrong ID", "zero", 0, 0);\n', '        }\n', '        else\n', '        {\n', '            return (shopSandwich[_sandwichId].sandwichName, shopSandwich[_sandwichId].sandwichDesc,\n', '                    shopSandwich[_sandwichId].calories, shopSandwich[_sandwichId].price, shopSandwich[_sandwichId].quantity);\n', '\n', '        }\n', '    }\n', '\n', '    function addToCart(uint _sandwichID, string _notes) returns (uint)\n', '    {\n', '        if( shopSandwich[_sandwichID].quantity > 0 )\n', '        {\n', '            OrderedSandwich memory newOrder;\n', '            newOrder.sandwichIdNumber = _sandwichID;\n', '            newOrder.notes = _notes;\n', '            newOrder.price = shopSandwich[_sandwichID].price;\n', '            subtotal[msg.sender] += newOrder.price;\n', '\n', '            return cart[msg.sender].push(newOrder);\n', '        }\n', '        else\n', '        {\n', '            return cart[msg.sender].length;\n', '        }\n', '    }\n', '\n', '\n', '    function getCartLength(address _curious) constant returns (uint)\n', '    {\n', '        return cart[_curious].length;\n', '    }\n', '\n', '    function getCartItemInfo(address _curious, uint _slot) constant returns (uint, string)\n', '    {\n', '        return (cart[_curious][_slot].sandwichIdNumber, cart[_curious][_slot].notes);\n', '    }\n', '\n', '    function emptyCart() public\n', '    {\n', '        delete cart[msg.sender];\n', '        subtotal[msg.sender] = 0;\n', '    }\n', '\n', '    function getCartSubtotal(address _curious) constant returns (uint)\n', '    {\n', '        return subtotal[_curious];\n', '    }\n', '\n', '    function checkoutCart(string _firstname) payable returns (uint)\n', '    {\n', '        if( msg.value < subtotal[msg.sender] ){ revert(); }\n', '\n', '        for( uint x = 0; x < cart[msg.sender].length; x++ )\n', '        {\n', '            if( shopSandwich[ cart[msg.sender][x].sandwichIdNumber ].quantity > 0 )\n', '            {\n', '                NewSandwichTicket( _firstname, msg.sender, \n', '                                   shopSandwich[ cart[msg.sender][x].sandwichIdNumber ].sandwichName,\n', '                                   cart[msg.sender][x].notes );\n', '                decrementQuantity( cart[msg.sender][x].sandwichIdNumber );\n', '            }\n', '            else\n', '            {\n', '                revert();\n', '            }\n', '        }\n', '        subtotal[msg.sender] = 0;\n', '        delete cart[msg.sender];\n', '        return now;\n', '    }\n', '\n', '    function transferFundsAdminOnly(address addr, uint amount) onlyOwner\n', '    {\n', '        if( amount <= this.balance )\n', '        {\n', '            addr.transfer(amount);\n', '        }\n', '    }\n', '\n', '    function decrementQuantity(uint _sandnum) private\n', '    {\n', '        shopSandwich[_sandnum].quantity--;\n', '    }\n', '\n', '    function setQuantityAdminOnly(uint _sandnum, uint _quantity) onlyOwner\n', '    {\n', '        shopSandwich[_sandnum].quantity = _quantity;\n', '    }\n', '\n', '    function killAdminOnly() onlyOwner\n', '    {\n', '        selfdestruct(owner);\n', '    }\n', '\n', '}']