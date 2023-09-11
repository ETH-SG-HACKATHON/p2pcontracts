export const abi = {
  Listings: [
    {
      inputs: [
        {
          internalType: "address",
          name: "_escrowFactory",
          type: "address",
        },
      ],
      stateMutability: "nonpayable",
      type: "constructor",
    },
    {
      inputs: [],
      name: "AmountLessThanZero",
      type: "error",
    },
    {
      inputs: [],
      name: "BankTransferNotVerified",
      type: "error",
    },
    {
      inputs: [],
      name: "NotBuyer",
      type: "error",
    },
    {
      inputs: [],
      name: "NotSeller",
      type: "error",
    },
    {
      inputs: [],
      name: "TradeInProgress",
      type: "error",
    },
    {
      inputs: [],
      name: "TradeNotInProgress",
      type: "error",
    },
    {
      inputs: [],
      name: "TradeNotOpen",
      type: "error",
    },
    {
      inputs: [
        {
          internalType: "uint256",
          name: "",
          type: "uint256",
        },
      ],
      name: "ads",
      outputs: [
        {
          internalType: "address",
          name: "seller",
          type: "address",
        },
        {
          internalType: "string",
          name: "token",
          type: "string",
        },
        {
          internalType: "uint256",
          name: "amount",
          type: "uint256",
        },
        {
          internalType: "uint256",
          name: "price",
          type: "uint256",
        },
        {
          internalType: "uint256",
          name: "duration",
          type: "uint256",
        },
        {
          internalType: "string",
          name: "paymentMethod",
          type: "string",
        },
        {
          internalType: "string",
          name: "name",
          type: "string",
        },
        {
          internalType: "string",
          name: "accountNumber",
          type: "string",
        },
        {
          internalType: "enum Listings.State",
          name: "state",
          type: "uint8",
        },
      ],
      stateMutability: "view",
      type: "function",
    },
    {
      inputs: [
        {
          internalType: "uint256",
          name: "adIndex",
          type: "uint256",
        },
      ],
      name: "closeAd",
      outputs: [],
      stateMutability: "nonpayable",
      type: "function",
    },
    {
      inputs: [
        {
          internalType: "uint256",
          name: "adIndex",
          type: "uint256",
        },
        {
          internalType: "address",
          name: "buyer",
          type: "address",
        },
      ],
      name: "confirmBuyer",
      outputs: [],
      stateMutability: "nonpayable",
      type: "function",
    },
    {
      inputs: [
        {
          internalType: "uint256",
          name: "",
          type: "uint256",
        },
      ],
      name: "confirmedBuyer",
      outputs: [
        {
          internalType: "address",
          name: "",
          type: "address",
        },
      ],
      stateMutability: "view",
      type: "function",
    },
    {
      inputs: [
        {
          internalType: "string",
          name: "_token",
          type: "string",
        },
        {
          internalType: "uint256",
          name: "_amount",
          type: "uint256",
        },
        {
          internalType: "uint256",
          name: "_price",
          type: "uint256",
        },
        {
          internalType: "uint256",
          name: "_duration",
          type: "uint256",
        },
        {
          internalType: "string",
          name: "_paymentMethod",
          type: "string",
        },
        {
          internalType: "string",
          name: "_name",
          type: "string",
        },
        {
          internalType: "string",
          name: "_accountNumber",
          type: "string",
        },
      ],
      name: "createAd",
      outputs: [],
      stateMutability: "nonpayable",
      type: "function",
    },
    {
      inputs: [],
      name: "escrowFactory",
      outputs: [
        {
          internalType: "contract EscrowFactoryContract",
          name: "",
          type: "address",
        },
      ],
      stateMutability: "view",
      type: "function",
    },
    {
      inputs: [
        {
          internalType: "uint256",
          name: "adIndex",
          type: "uint256",
        },
      ],
      name: "getAd",
      outputs: [
        {
          components: [
            {
              internalType: "address",
              name: "seller",
              type: "address",
            },
            {
              internalType: "string",
              name: "token",
              type: "string",
            },
            {
              internalType: "uint256",
              name: "amount",
              type: "uint256",
            },
            {
              internalType: "uint256",
              name: "price",
              type: "uint256",
            },
            {
              internalType: "uint256",
              name: "duration",
              type: "uint256",
            },
            {
              internalType: "string",
              name: "paymentMethod",
              type: "string",
            },
            {
              internalType: "string",
              name: "name",
              type: "string",
            },
            {
              internalType: "string",
              name: "accountNumber",
              type: "string",
            },
            {
              internalType: "enum Listings.State",
              name: "state",
              type: "uint8",
            },
          ],
          internalType: "struct Listings.SellAd",
          name: "",
          type: "tuple",
        },
      ],
      stateMutability: "view",
      type: "function",
    },
    {
      inputs: [],
      name: "getAdCount",
      outputs: [
        {
          internalType: "uint256",
          name: "",
          type: "uint256",
        },
      ],
      stateMutability: "view",
      type: "function",
    },
    {
      inputs: [
        {
          internalType: "uint256",
          name: "page",
          type: "uint256",
        },
        {
          internalType: "uint256",
          name: "perPage",
          type: "uint256",
        },
      ],
      name: "getAds",
      outputs: [
        {
          components: [
            {
              internalType: "address",
              name: "seller",
              type: "address",
            },
            {
              internalType: "string",
              name: "token",
              type: "string",
            },
            {
              internalType: "uint256",
              name: "amount",
              type: "uint256",
            },
            {
              internalType: "uint256",
              name: "price",
              type: "uint256",
            },
            {
              internalType: "uint256",
              name: "duration",
              type: "uint256",
            },
            {
              internalType: "string",
              name: "paymentMethod",
              type: "string",
            },
            {
              internalType: "string",
              name: "name",
              type: "string",
            },
            {
              internalType: "string",
              name: "accountNumber",
              type: "string",
            },
            {
              internalType: "enum Listings.State",
              name: "state",
              type: "uint8",
            },
          ],
          internalType: "struct Listings.SellAd[]",
          name: "",
          type: "tuple[]",
        },
      ],
      stateMutability: "view",
      type: "function",
    },
    {
      inputs: [
        {
          internalType: "uint256",
          name: "adIndex",
          type: "uint256",
        },
      ],
      name: "getConfirmedBuyer",
      outputs: [
        {
          internalType: "address",
          name: "",
          type: "address",
        },
      ],
      stateMutability: "view",
      type: "function",
    },
    {
      inputs: [
        {
          internalType: "uint256",
          name: "adIndex",
          type: "uint256",
        },
      ],
      name: "getInterestedBuyers",
      outputs: [
        {
          internalType: "address[]",
          name: "",
          type: "address[]",
        },
      ],
      stateMutability: "view",
      type: "function",
    },
    {
      inputs: [
        {
          internalType: "uint256",
          name: "",
          type: "uint256",
        },
        {
          internalType: "uint256",
          name: "",
          type: "uint256",
        },
      ],
      name: "interestedBuyers",
      outputs: [
        {
          internalType: "address",
          name: "",
          type: "address",
        },
      ],
      stateMutability: "view",
      type: "function",
    },
    {
      inputs: [
        {
          internalType: "address",
          name: "_escrowFactory",
          type: "address",
        },
      ],
      name: "setEscrowFactory",
      outputs: [],
      stateMutability: "nonpayable",
      type: "function",
    },
    {
      inputs: [
        {
          internalType: "uint256",
          name: "adIndex",
          type: "uint256",
        },
      ],
      name: "showInterest",
      outputs: [],
      stateMutability: "nonpayable",
      type: "function",
    },
    {
      inputs: [
        {
          internalType: "uint256",
          name: "adIndex",
          type: "uint256",
        },
      ],
      name: "startTrade",
      outputs: [],
      stateMutability: "nonpayable",
      type: "function",
    },
    {
      inputs: [
        {
          internalType: "uint256",
          name: "adIndex",
          type: "uint256",
        },
      ],
      name: "verifyBankTransfer",
      outputs: [],
      stateMutability: "nonpayable",
      type: "function",
    },
  ],
};

export const contractAddresses = {
  80001: {
    Listings: "0xabc39c8550e42ef9ba6aafae47a27a2774977a5d",
  },
};
