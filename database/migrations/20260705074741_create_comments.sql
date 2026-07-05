-- +goose Up
CREATE TABLE comments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    post_id INT NOT NULL,
    author_name VARCHAR(255) NOT NULL,
    content TEXT NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_comments_post 
        FOREIGN KEY (post_id) 
        REFERENCES posts(id)
        ON DELETE CASCADE
);

-- +goose Down
DROP TABLE comments;
