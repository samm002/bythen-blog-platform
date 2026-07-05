-- +goose Up
INSERT INTO users (id, name, email, password_hash) VALUES
    (1, 'Baskara Putra', 'baskara@mail.com', '$2a$12$kIhFaEvWSlWJmbCz8eYmgOcc/DryHCd/JEWR/3vIbmQbeBDq22an6'), -- plain password: password123
    (2, 'Maudy Ayunda', 'maudy@mail.com', '$2a$12$L8PNMwVW4Zff2u9IPRDgfuJjoOzlmhonxNmOt2l61W2OTRYhtQWjy'), -- plain password: password234
    (3, 'Tirta Mandira Hudhi', 'tirta@mail.com', '$2a$12$pTD7XGgykgxNlo51TeJ3ou9mGMb4AdihEF.u7OpxP66JT15aBT.dm'); -- plain password: password 345

INSERT INTO posts (id, title, content, author_id) VALUES
    (1, 'Finding Inspiration Through Music', 'Music has always been my way of expressing emotions and telling stories.', 1),
    (2, 'Behind the Lyrics', 'Every lyric begins with a simple idea that evolves over time.', 1),
    (3, 'The Creative Process of Songwriting', 'Writing songs is about observing everyday life and turning it into melodies.', 1),

    (4, 'Balancing Career and Education', 'Managing both requires discipline and clear priorities.', 2),
    (5, 'Why Lifelong Learning Matters', 'Learning should continue long after graduation.', 2),
    (6, 'Stepping Outside Your Comfort Zone', 'Growth often begins where comfort ends.', 2),

    (7, 'Why Staying Hydrated Matters', 'Proper hydration supports overall health and daily performance.', 3),
    (8, 'Simple Habits for Better Sleep', 'Quality sleep is one of the most overlooked aspects of health.', 3),
    (9, 'Building Sustainable Healthy Habits', 'Small consistent changes lead to lasting results.', 3);

INSERT INTO comments (post_id, author_name, content) VALUES
    (1, 'Andi', 'Your music always inspires me!'),
    (1, 'Sinta', 'Looking forward to your next album.'),

    (2, 'Rizky', 'I never knew the meaning behind your lyrics.'),
    (2, 'Nadia', 'Beautiful explanation!'),

    (3, 'Fajar', 'Very insightful.'),
    (3, 'Putri', 'Thanks for sharing your creative process.'),

    (4, 'Kevin', 'This is very motivating!'),
    (4, 'Alya', 'I needed this reminder.'),

    (5, 'Budi', 'Could not agree more.'),
    (5, 'Nisa', 'Education never stops.'),

    (6, 'Rio', 'Amazing perspective.'),
    (6, 'Dewi', 'Thank you for the encouragement.'),

    (7, 'Yoga', 'I started drinking more water because of this!'),
    (7, 'Maya', 'Great health reminder.'),

    (8, 'Doni', 'Sleep really changes everything.'),
    (8, 'Clara', 'Very practical advice.'),

    (9, 'Arif', 'Consistency is definitely the hardest part.'),
    (9, 'Intan', 'Love these healthy tips!');

-- +goose Down
DELETE FROM users
WHERE email IN (
    'baskara@mail.com',
    'maudy@mail.com',
    'tirta@mail.com'
);
