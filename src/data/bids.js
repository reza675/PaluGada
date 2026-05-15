// Mock data: bids table
// FK: artwork_id → artworks.id
// bidder comes from mobile app (collector), so we store bidder_name and bidder_email

const bids = [
  {
    id: 1,
    artwork_id: 1, // Matahari Terbenam di Parangtritis
    bidder_name: 'Hendra Wijaya',
    bidder_email: 'hendra@mail.com',
    bid_amount: 16000000,
    bid_time: '2025-07-01T10:30:00Z',
    status: 'outbid',
  },
  {
    id: 2,
    artwork_id: 1,
    bidder_name: 'Lisa Tanaka',
    bidder_email: 'lisa.t@mail.com',
    bid_amount: 18500000,
    bid_time: '2025-07-02T14:15:00Z',
    status: 'outbid',
  },
  {
    id: 3,
    artwork_id: 1,
    bidder_name: 'Robert Chen',
    bidder_email: 'robert.c@mail.com',
    bid_amount: 22000000,
    bid_time: '2025-07-03T09:45:00Z',
    status: 'active',
  },
  {
    id: 4,
    artwork_id: 2, // Sawah Terasering Ubud
    bidder_name: 'Amanda Putri',
    bidder_email: 'amanda.p@mail.com',
    bid_amount: 13000000,
    bid_time: '2025-07-15T11:00:00Z',
    status: 'outbid',
  },
  {
    id: 5,
    artwork_id: 2,
    bidder_name: 'David Hartono',
    bidder_email: 'david.h@mail.com',
    bid_amount: 15000000,
    bid_time: '2025-07-16T16:30:00Z',
    status: 'active',
  },
  {
    id: 6,
    artwork_id: 3, // Ombak Biru Nusantara
    bidder_name: 'Yuki Sato',
    bidder_email: 'yuki.s@mail.com',
    bid_amount: 27000000,
    bid_time: '2025-07-20T08:00:00Z',
    status: 'outbid',
  },
  {
    id: 7,
    artwork_id: 3,
    bidder_name: 'Patrick Muller',
    bidder_email: 'patrick.m@mail.com',
    bid_amount: 30000000,
    bid_time: '2025-07-21T13:20:00Z',
    status: 'outbid',
  },
  {
    id: 8,
    artwork_id: 3,
    bidder_name: 'Cindy Lau',
    bidder_email: 'cindy.l@mail.com',
    bid_amount: 35000000,
    bid_time: '2025-07-22T10:10:00Z',
    status: 'active',
  },
  {
    id: 9,
    artwork_id: 5, // Dewi Sri Modern
    bidder_name: 'Takeshi Yamamoto',
    bidder_email: 'takeshi.y@mail.com',
    bid_amount: 38000000,
    bid_time: '2025-06-01T09:00:00Z',
    status: 'outbid',
  },
  {
    id: 10,
    artwork_id: 5,
    bidder_name: 'Maria Santos',
    bidder_email: 'maria.s@mail.com',
    bid_amount: 42000000,
    bid_time: '2025-06-02T15:45:00Z',
    status: 'active',
  },
  {
    id: 11,
    artwork_id: 2,
    bidder_name: 'James Kim',
    bidder_email: 'james.k@mail.com',
    bid_amount: 14500000,
    bid_time: '2025-07-16T10:00:00Z',
    status: 'outbid',
  },
];

export default bids;
